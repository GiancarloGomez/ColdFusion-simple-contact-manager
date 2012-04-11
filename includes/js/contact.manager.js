(function($){
	$.widget('demo.contact_manager',{
		
		options:{
			url 	: 'ajax/contact.cfc',
			delay	: 200
		},
		
		_create: function(){
			var self = this;
			
			this.people 		= [];
			this.people_in_view = [];
			this.search_results = [];
			this.header 		= this.element.find('.search');
			this.goback 		= this.element.find('.back');
			this.records 		= this.element.find('.records');
			this.editor 		= this.element.find('.editor');
			this.form			= this.editor.find('form');
			this.loading		= this.element.find('.loading');
			this.searchfield 	= this.header.find('input');
			
			// setup create link
			this._activeLink(this.element.find('a.create'));
			// setup editor cancel/back links
			this._activeLink(this.editor.find('a.cancel'));
			this._activeLink(this.goback.find('a'));
			// setup form listener
			this.form.on('submit',function(){
				return self._submitData(this);
			});
			// setup search
			this.searchfield.keyup($.debounce( self.options.delay,function(){self._searchContacts()}));
			// go fetch contacts
			this._getContacts();		
		},
		
		destroy: function(){
			$.Widget.prototype.destroy.call(this);
		},
		
		_activeLink : function (element){
			var self = this;
			
			$(element).on('click',function(event){
				event.stopImmediatePropagation();
				event.preventDefault();
				
				var me 		= $(this),
					parent,
					person;
				
				$.each(['edit','delete','more'],function(a,b){
						if (me.data('role') === b){
							parent 	= me.parents('.person');
							person	= self.people_in_view[parent.data('row')];
							return false;
						}
				});
				
				switch (me.data('role')){
					case 'edit' :
						self._showHideForm(person);
					break;
					
					case 'delete' :
						self._deleteContactConfirm(parent.data('row'),person);
					break;
					
					case 'cancel' :
						self._showHideForm();
					break;
					
					case 'create' :
						self._showHideForm({name:'',phone:'',email:'',contactid:0});
					break;
					
					default:
						var info = parent.find('.data');
						if(info.css('display') == 'none')
							info.slideDown(250);
						else
							info.slideUp(250);
					break;	
				}
			});
		},
		
		_activateLinks : function(){
			var self = this;
			var links = this.element.find('a');
			$.each(links,function(){
				self._activeLink(this);
			});
		},
		
		_deleteContactConfirm : function(row,person){
			/* old alert way
				if (confirm('Are you sure you want to delete ' + person.name + '?')){
					self._deleteContact(parent.data('row'),person);	
				}
			*/
			var self = this,
				o = {
				message : 'Are you sure you want to delete ' + person.name + '?',
				buttons	: {
					"Delete Contact": function() {
						self._deleteContact(row,person,document.getElementById('dialog'));
					},
					Cancel: function() {
						$("#dialog").dialog( "close" );
					}
				}				
			};
			this._openDialog(o);
		},
		
		_deleteContact : function(row,obj,dialog){
			var self = this;
			obj.method = 'delete';
			$.ajax({
				url : this.options.url,
				data: obj,
				success: function(d){
					$( dialog ).dialog( "close" );
					self.element.find('#contact_' + obj.contactid).remove();
					self.people.splice(row,1);
					if(self.search_results > 0 || self.searchfield.val() != "")
						self._searchContacts();
					else
						self._writeHTML();
				}
			});
		},
		
		_getContacts : function(){
			var self = this;
			// show loading
			this._showLoading(true);
			// lets get our data and populate the ui
			$.ajax({
				url : this.options.url,
				data:'method=getContacts',
				success: function(d){
					var columns = d.columns || d.COLUMNS,
						rows	= d.data || d.DATA;
					$.each(rows,function(){
						var person = {};
						for(i in columns){
							person[columns[i].toLowerCase()]= this[i];
						}
						self.people.push(person);
					});
					// go and write the html
					self._writeHTML();
				}
			});	
		},
		
		_openDialog : function(obj){
			var self = this;
			// create dialog if it does not exists
			if(document.getElementById('dialog') == null)
				$('body').append('<div id="dialog"></div>');
			// open dialog
			$('#dialog').html(obj.message).dialog({
				resizable: false,
				modal: true,
				width:400,
				minHeight:100,
			    create: function (event, ui) {
			      $('.ui-widget-header').hide();
			    },
				buttons: obj.buttons
			});
		},
				
		_postContact : function(obj){
			var self = this;
			obj += '&method=post';
			this._showLoading(true);
			$.ajax({
				url : this.options.url,
				data: obj,
				success: function(d){
					self._updateLocalContact(d);
				}
			});
		},
		
		_searchContacts : function(){
			var self = this,
				value = this.searchfield.val(),
				reg = new RegExp('^' + value,'i'); // search left to right case-insensitive
			
			// clear results
			this.search_results = [];
			
			$.each(this.people,function(){
				if(this.name.match(reg))
				self.search_results.push(this);
			});
			
			this._writeHTML();
		},
		
		_setOption: function (key,value){
			$.Widget.prototype._setOption.apply( this, arguments );	
		},
		
		_showHideForm : function(obj){
			if (obj != undefined){
				this.header.hide();
				this.records.hide();
				this.goback.show();
				this.editor.show();
				// set data values
				for(i in obj)
					this.form[0][i].value = obj[i];									
			}else{
				this.goback.hide();
				this.editor.hide();
				this.header.show();
				this.records.show();
			}
		},
		
		_showLoading : function (show){
			if (show === undefined || show === false)
				this.loading.hide();
			else
				this.loading.show();	
		},
		
		_sortResults : function(prop, asc){
			function cmp(a,b){
				if (asc) return (a[prop] > b[prop]) ? 1 : -1;
				else return (a[prop] < b[prop]) ? 1 : -1;
			}
			this.people = this.people.sort(cmp);
		},
		
		_submitData : function(form){
			var msg = [];
			
			$('input.required', form).each(function () {
				var field = $(this);
				if (
					field.val() == '' 
					||
					(field.hasClass('email') && !validateEmail(field.val()))
				){
					if (field.attr('title')) {
						msg.push(field.attr('title'));
					} else {
						msg.push(field.attr('name') + '  is a required field');
					}
				}
			});
			
			if (msg.length > 0){
				// alert user of errors
				// alert('Attention:\n' + msg.join('\n'));
				var alertmsg = 'Attention:<ul>';
				for(i in msg)
					alertmsg += '<li>' + msg[i] + '</li>';
				alertmsg += '</ul>';
				var o = {
					message : alertmsg,
					buttons : {
						OK: function() {
							$( this ).dialog( "close" );
						}
					}
				};
				this._openDialog(o);
			}else{
				// post data
				this._postContact($(form).serialize());
			}
			return false;	
		},
		
		_updateLocalContact : function (obj){
			var self 	= this,
				found 	= false;
			$.each(this.people,function(){
				// in order to handle different results from cf
				if(this.contactid == (obj.contactID || obj.contactid || obj.CONTACTID)){
					this.contactid 	= obj.contactID || obj.contactid || obj.CONTACTID;
					this.name 		= obj.name || obj.NAME;
					this.email 		= obj.email || obj.EMAIL;
					this.phone 		= obj.phone || obj.PHONE;
					found = true;
					return false;
				}
			});
			// if a new record
			if (found === false){
				person = {
					contactid : obj.contactID || obj.contactid || obj.CONTACTID,
					name 		: obj.name || obj.NAME,
					email 		: obj.email || obj.EMAIL,
					phone 		: obj.phone || obj.PHONE
				}
				this.people.push(person);
				// clear search results if adding
				this.search_results = [];
			}
			this._sortResults('name',true);
			this._writeHTML();
			this._showHideForm();
		},
		
		_writeHTML : function(){
			var string = "";
			
			if (this.search_results.length > 0 || this.searchfield.val() != "")
				this.people_in_view = this.search_results;
			else
				this.people_in_view = this.people;
				
			if (this.people_in_view == 0){
				string += '<li class="norecords">No records found</li>';
			}else{
				$.each(this.people_in_view,function(i){
					string += '<li class="person" id="contact_'+ this.contactid +'" data-id="'+ this.contactid +'" data-row="'+ i +'">' + 
					'<div class="links">' +
					'	<a href="" data-role="more">more</a> |' +
					'	<a href="" data-role="edit">edit</a> |' +
					'	<a href="" data-role="delete">delete</a>' +
					'</div>' +
					'<span>' + this.name + '</span>' +
					'<div class="data"><dl>' +
					'<dt>name:</dt><dd>' + this.name + '</dd>' +
					'<dt>phone:</dt><dd>' + this.phone + '</dd>' +
					'<dt>email:</dt><dd>' + this.email + '</dd>' +
					'</dl></div></li>';
				});
			}
			this.records.html(string);
			// now go and activate all the links
			this._activateLinks();
			this._showLoading(false);
		}
	});
}(jQuery));

// simple email validation
function validateEmail(id) {
	return /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/i.test(id);
}


