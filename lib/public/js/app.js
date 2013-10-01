(function ($) {

    var Shewbot = {};
    window.Shewbot = Shewbot;

    Shewbot.Title = Backbone.Model.extend({
    });

    Shewbot.Titles = Backbone.Collection.extend({
        url: "/titles",
        model: Shewbot.Title
    })

    Shewbot.TitleView = Backbone.View.extend({
        tagName: "tr",
        className: "title",
        events: {},
        template: $("#titleTemplate").html(),

        render: function() {
            var tmpl = _.template(this.template);

            this.$el.html(tmpl(this.model.toJSON()));
            console.log(this);
            return this;
        }
    });

    Shewbot.TitleCollectionView = Backbone.View.extend({
        tagName: "table",
        className: "table",
        template: $("#headerTemplate").html(),
        comparator: "vote_count",
        initialize: function( titleSet ) {
            this.titles = new Shewbot.Titles ( titleSet );
            this.titles.on('all', this.render, this);
            this.titles.on('all', function() {
                console.log("event on title collection", arguments);
            });
            this.titles.fetch();
            this.interval = window.setInterval( _.bind( function() { this.titles.fetch(); }, this ), 10000);
        },
        render: function() {
            console.log("TitleCollectionView render");
            console.log(this.titles);
            this.$el.empty();

            this.$el.append(this.template);

            this.titles.each(function(title) {
                console.log("TitleCollectionView render each title");
                var view = new Shewbot.TitleView({model: title});
                this.$el.append(view.render().el);
            }, this);
            return this;
        },


    });

    Shewbot.boot = function(container, titleSet ) {
        container = $(container);
        titleTable = new Shewbot.TitleCollectionView( titleSet );
        container.empty();
        container.append(titleTable.render().el);
    }

} (jQuery));

