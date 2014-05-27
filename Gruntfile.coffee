timer = require "grunt-timer"

module.exports = (grunt) ->

    timer.init grunt

    require("load-grunt-tasks") grunt,
        pattern: ["grunt-*", "!grunt-timer"]

    grunt.initConfig
        scssFiles = ["assets/{styles,css}/*.scss", "*/static/{styles,css}/*.scss"]
        coffeeFiles = ["assets/{scripts,js}/*.coffee", "*/static/{scripts,js}/*.coffee"]
        tmpDir = ".tmp"
        distDir = "dist"

        sass:
            dev:
                files:
                    expand: true
                    cwd: "../"  # the main django project dir
                    src: scssFiles
                    dest: "<% tmpDir %>/css/"
                    ext: ".css"

            prod:
                files:
                    expand: true
                    cwd: "../"  # the main django project dir
                    src: scssFiles
                    dest: "<% distDir %>/main.css"

        coffee:
            dev:
                files:
                    src: coffeeFiles
                    dest: "<% tmpDir %>/js/"
            prod:
                files:
                    src: coffeeFiles
                    dest: "<% distDir %>/app.js"

        clean:
            dev:
                src: "<% tmpDir %>/*"

            prod:
                src: "<% distDir %>/*"

        manifest:
            dev:
                src: ["<%= tmpDir %>/app.js", "<%= tmpDir %>/*.css"]
                dest: "<%= tmpDir %>"
            prod:
                src: ["<%= distDir %>/app.js", "<%= distDir %>/*.css"]
                dest: "<%= distDir %>"

        watch:
            options:
                livereload: true
            scss:
                files: scssFiles
                tasks: ["sass"]
            coffee:
                files: coffeeFiles
                tasks: ["build"]
            grunt:
                files: ["Gruntfile.coffee"]
                tasks: ["build"]

        connect:
            dev:
                options:
                    port: 8001
                    debug: true
                    keepalive: false


    grunt.registerMultiTask 'manifest', 'Write the manifest in JSON to asset-manifest.json', ->
        manifest = css: [], js: []
        grunt.log.writeln('Processing ' + @filesSrc.length + ' files.');
        @filesSrc.forEach (file) ->
            if file.match('css$')
                manifest['css'].push file
            if file.match('js$')
                manifest['js'].push file
        console.log "Written".yellow, "#{@data.dest}/asset-manifest.json"

        grunt.file.write "#{@data.dest}/asset-manifest.json", JSON.stringify manifest, null, 2  # indent 2 spaces


    grunt.registerTask 'build', ['clean:dev', 'coffee:dev', 'sass:dev',
                                   'manifest:dev']
    grunt.registerTask 'dist', ['clean:prod', 'coffee:prod', 'sass:prod',
                                'manifest:prod']
    grunt.registerTask 'default', ['build', 'connect', 'watch']
