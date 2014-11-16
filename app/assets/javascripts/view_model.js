$(function(){

  function viewModel(){
    var self = this;

    // Observables
    self.project_list = ko.observableArray();
    self.project = {
      	id: ko.observable(),
      	name: ko.observable().extend({ rateLimit: 100 }),
      	color: ko.observable('#eeeeee'),
        editing: false
      }
    self.tasks = ko.observableArray();
    self.errors = ko.observableArray([]);
    self.loading = ko.observable(0);

    // Methods
    self.queueUp = function(){ self.loading(self.loading() + 1) }
    self.queueDown = function (){ self.loading(self.loading() - 1) }

    self.clearProject = function(){
      self.project.id(null);
      self.project.name(null);
      self.project.color(self.randomColor());
      self.tasks.removeAll();
      focusTitle();
    }

    self.clearError = function(error){
      self.errors.remove(error);
    }

    self.openProject = function(obj){
      self.getProject(obj.id);
    }

    self.editTask = function(obj){
      obj.editing(true);
    }

    self.saveProject = function(obj){
      var data = {
        name: self.project.name(),
        color: self.project.color()
      }
      self.postProject(self.project.id(), data);
    }

    self.destroyProject = function(obj){
      self.deleteProject(self.project.id());
    }

    self.addTask = function(){
      var task = self.buildTask('', false, null, self.project.id(), true);
      self.tasks.push(task);
      focusTask();
    }

    self.buildTask = function(name, completed, id, project_id, editing){
      return { 
        name: ko.observable(name).extend({ rateLimit: 500 }), 
        completed: ko.observable(completed), 
        id: ko.observable(id), 
        project_id: ko.observable(self.project.id()), 
        editing: ko.observable(editing) 
      }
    }

    self.saveTask = function(obj){
      obj.editing(false);
      var data = {
        name: obj.name(),
        completed: obj.completed()
      }
      self.postTask(obj.id(), obj.project_id(), data);
    }

    // via Culero Connor http://www.paulirish.com/2009/random-hex-color-code-snippets/
    self.randomColor = function(){ return '#'+(Math.random().toString(16) + '0000000').slice(2, 8) }

    // API calls
    self.getProjectList = function(){
      return $.ajax({
        url: "/projects",
        method: 'GET',
        dataType: 'json',
        beforeSend: self.queueUp,
        complete: self.queueDown,
        success: function(data, status, jqXHR){ 
          self.project_list(data);
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

    self.postProject = function(id, data){
      var url, method;

      if(id != undefined){
        url = "/projects/"+id;
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
            self.getProjectList(data.id);
            self.project.id(data.id);
          },
          error: function(jqXHR, status, error){ 
            self.errors.push("Could not save project: "+error) 
          }
        });
      }
    }

    self.deleteProject = function(id){
      return $.ajax({
        url: "/projects/"+id,
        method: 'DELETE',
        dataType: 'json',
        beforeSend: self.queueUp,
        complete: self.queueDown,
        success: function(data, status, jqXHR){ 
          self.clearProject();
          self.getProjectList()
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
  function focusTask(){ $('#project_title').focus(); }

  function highlightNav(id){
    $('.project-list__item a').removeClass('active');
    if(id != null){
      $('.project-list__item a[data-project-id='+id+']').addClass('active');
    }
  }


  function selectLatest(){
    // Find the most recently updated of the projects and return it
    var latest = $('.project-list__item').first();
    $('.project-list__item').each(function(i){
      var $this = $(this),
          ours = $this.find('a').data('project-updated'),
          theirs = latest.find('a').data('project-updated');
      if(ours > theirs){
        latest = $this;
      }
    });
    return latest;
  }

  (function(){
    var view_model = new viewModel();
    ko.applyBindings(view_model);
    subscribers(view_model);
    view_model.getProjectList().done(function(){
      var latest = selectLatest();
      if(latest != undefined){
        view_model.getProject(latest.find('a').data('project-id'));
      }
    });
    focusTitle();
  })();



})
