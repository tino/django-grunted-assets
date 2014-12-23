timer = require "grunt-timer"

module.exports = (grunt) ->

    timer.init grunt

    require("load-grunt-tasks") grunt,
        pattern: ["grunt-*", "!grunt-timer"]

    grunt.initConfig
        scssFiles: ["test-assets/{styles,css}/*.scss", "*/static/{styles,css}/*.scss"]
        coffeeFiles: ["test-assets/{scripts,js}/*.coffee", "*/static/{scripts,js}/*.coffee"]
        tmpDir: ".tmp"
        distDir: "dist"

        sass:
            dev:
                files: [
                    src: "<%= scssFiles %>"
                    dest: "<%= tmpDir %>/main.css"
                ]

            prod:
                outputStyle: "compressed"
                sourceMap: true
                files: [
                    src: "<%= scssFiles %>"
                    dest: "<%= distDir %>/main.css"
                ]

        coffee:
            dev:
                files: [
                    src: "<%= coffeeFiles %>"
                    dest: "<%= tmpDir %>/app.js"
                ]
            prod:
                join: true
                sourceMap: true
                files: [
                    src: "<%= coffeeFiles %>"
                    dest: "<%= distDir %>/app.js"
                ]

        clean:
            dev:
                src: "<%= tmpDir %>/*"

            prod:
                src: "<%= distDir %>/*"

        rev:
            prod:
                expand: true
                files: [
                    src: "<%= distDir %>/*.{js,css}"
                ]


        watch:
            options:
                livereload: true
            scss:
                files: "<%= scssFiles %>"
                tasks: ["sass"]
            coffee:
                files: "<%= coffeeFiles %>"
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

    grunt.registerTask 'build', ['clean:dev', 'coffee:dev', 'sass:dev']
    grunt.registerTask 'dist', ['clean:prod', 'coffee:prod', 'sass:prod', 'rev:prod']
    grunt.registerTask 'default', ['build', 'connect', 'watch']
