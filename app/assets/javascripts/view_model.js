$(function(){

  function viewModel(){
    var self = this;

    // Observables
    self.project_list = ko.observableArray();
    self.project = {
      	id: ko.observable(),
      	name: ko.observable(''),
      	color: ko.observable('#666'),
        editing: ko.observable(true)
      }
    self.tasks = ko.observableArray();
    self.errors = ko.observableArray([]);
    self.loading = ko.observable(0);

    // Methods
    self.queueUp = function(){ self.loading(self.loading() + 1) }
    self.queueDown = function (){ self.loading(self.loading() - 1) }

    self.clearProject = function(editing){
      self.project.id(null);
      self.project.name('');
      self.project.color(self.randomColor());
      self.project.editing(true);
      self.tasks.removeAll();
      focusTitle();
    }

    self.clearError = function(error){
      self.errors.remove(error);
    }

    self.openProject = function(obj){
      self.getProject(obj.id());
      self.project.editing(false);
    }

    self.editObj = function(obj){
      obj.editing(true);
    }

    self.newTask = function(){
      var task = self.buildTask('', false, null, self.project.id(), true);
      self.tasks.push(task);
      focusTask();
    }

    self.buildMenuProject = function(name, color, id, updated_since_epoch){
      return {
        name: ko.observable(name), 
        color: ko.observable(color), 
        id: ko.observable(id), 
        updated_since_epoch: ko.observable(updated_since_epoch)     
      }
    }

    self.buildTask = function(name, completed, id, project_id, editing){
      return { 
        name: ko.observable(name), 
        completed: ko.observable(completed), 
        id: ko.observable(id), 
        project_id: ko.observable(self.project.id()), 
        editing: ko.observable(editing) 
      }
    }

    // via Culero Connor http://www.paulirish.com/2009/random-hex-color-code-snippets/
    self.randomColor = function(){ return '#'+(Math.random().toString(16) + '0000000').slice(2, 8) }

    self.selectLatest = function(){
      // Find the most recently updated of the projects in the projects_list
      var latest = self.project_list()[0];
      $.each(self.project_list(), function(i){
        var ours = this.updated_since_epoch(),
            theirs = latest.updated_since_epoch();
        if(ours > theirs){
          latest = this;
        }
      });
      return latest;
    }

    // API calls
    self.getProjectList = function(){
      return $.ajax({
        url: "/projects",
        method: 'GET',
        dataType: 'json',
        beforeSend: self.queueUp,
        complete: self.queueDown,
        success: function(data, status, jqXHR){
          self.project_list.removeAll();
          $.each(data, function(i){
            var menu_project = self.buildMenuProject(this.name, this.color, this.id, this.updated_since_epoch);
            self.project_list.push(menu_project);
          })
        },
        error: function(jqXHR, status, error){ 
          self.errors.push("Could not get projects: "+error) 
        }
      });
    }

    self.getProject = function(id){
      return $.ajax({
        url: "/projects/"+id,
        method: 'GET',
        dataType: 'json',
        beforeSend: self.queueUp,
        complete: self.queueDown,
        success: function(data, status, jqXHR){ 
          self.project.id(data.id);
          self.project.name(data.name);
          self.project.color(data.color);
          self.tasks.removeAll();
          if(data.tasks != undefined){
            $.each(data.tasks, function(i){
              var task = self.buildTask(this.name, this.completed, this.id, data.id, false);
              self.tasks.push(task);
            });
          }
        },
        error: function(jqXHR, status, error){ 
          self.errors.push("Could not get project: "+error) 
        }
      });
    }

    self.postProject = function(obj){
      var data = {
        name: obj.name(),
        color: obj.color()
      }, url, method;

      obj.editing(false);
      if(obj.id() != undefined){
        url = "/projects/"+obj.id();
        method = "PATCH"
      }else{
        url = "/projects";
        method = "POST"
      }
      if(data.name.length > 0){
        return $.ajax({
          url: url,
          method: method,
          dataType: 'json',
          data: { project: data },
          beforeSend: self.queueUp,
          complete: self.queueDown,
          success: function(data, status, jqXHR){ 
            if(obj.id() != undefined){ // this was an update, shold already be in menu
              $.each(self.project_list(), function(i){
                if(this.id() == obj.id()){
                  this.name(data.name);
                }
              });
            }else{
              var menu_project = self.buildMenuProject(data.name, data.color, data.id, data.updated_since_epoch);
              self.project_list.push(menu_project);
              obj.id(data.id);
            }
          },
          error: function(jqXHR, status, error){ 
            obj.editing(true);
            self.errors.push("Could not save project: "+error) 
          }
        });
      }
    }

    self.deleteProject = function(obj){
      return $.ajax({
        url: "/projects/"+obj.id(),
        method: 'DELETE',
        dataType: 'json',
        beforeSend: self.queueUp,
        complete: self.queueDown,
        success: function(data, status, jqXHR){ 
          self.project_list.remove(function(project) { return project.id() == obj.id() })
          self.clearProject();
        },
        error: function(jqXHR, status, error){ 
          self.errors.push("Could not delete project: "+error) 
        }
      });
    }

    self.postTask = function(obj){
      var url, method,
          data = {
            name: obj.name(),
            completed: obj.completed()
          }
      obj.editing(false);
      if(obj.id() != undefined){
        url = "/projects/"+obj.project_id()+"/tasks/"+obj.id();
        method = "PATCH"
      }else{
        url = "/projects/"+obj.project_id()+"/tasks/";
        method = "POST"
      }
      if(data.name.length > 0){
        return $.ajax({
          url: url,
          method: method,
          dataType: 'json',
          data: { task: data },
          beforeSend: self.queueUp,
          complete: self.queueDown,
          success: function(data, status, jqXHR){
            obj.id(data.id);
          },
          error: function(jqXHR, status, error){
            obj.editing(true);
            self.errors.push("Could not save task: "+error) 
          }
        });
      }
    }

    self.deleteTask = function(obj){
      if(obj.id() != undefined){
        return $.ajax({
          url: "/projects/"+obj.project_id()+"/tasks/"+obj.id(),
          method: 'DELETE',
          dataType: 'json',
          beforeSend: self.queueUp,
          complete: self.queueDown,
          success: function(data, status, jqXHR){ 
            self.tasks.remove(function(task) { return task.id() == obj.id() })
          },
          error: function(jqXHR, status, error){ 
            self.errors.push("Could not delete task: "+error) 
          }
        });
      }else{
        self.tasks.remove(obj)
      }
    }

  }; // END viewModel

  // Subscribers
  function subscribers(view_model){
    view_model.project.id.subscribe(function(new_id) { highlightNav(new_id) });
    view_model.project_list.subscribe(function(new_list) { highlightNav(view_model.project.id()) });
  }

  // DOM Methods
  function focusTitle(){ $('#project_title').focus(); }
  function focusTask(){ $('.tasks input').last().focus(); }

  function highlightNav(id){
    $('.project-list__item a').removeClass('active');
    if(id != null){
      $('.project-list__item a[data-project-id='+id+']').addClass('active');
    }
  }

  (function(){
    var view_model = new viewModel();
    ko.applyBindings(view_model);
    subscribers(view_model);
    view_model.getProjectList().done(function(){
      var latest = view_model.selectLatest();
      if(latest != undefined){
        view_model.getProject(latest.id());
        view_model.project.editing(false);
      }
    });
    focusTitle();
  })();

})
