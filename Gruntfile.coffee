module.exports = (grunt) ->
	vars = {
		scripts: [
			'bower_components/lodash/dist/lodash.js'
			'bower_components/angular/angular.js'
			'bower_components/angular-route/angular-route.js'
			'bower_components/angular-sanitize/angular-sanitize.js'
			'bower_components/marked/lib/marked.js'
			'scripts/app.js'
			'scripts/services/fetch.js'
			'scripts/services/poems.js'
			'scripts/services/reader/_factory.js'
			'scripts/services/reader/markdown.js'
			'scripts/services/reader/json.js'
			'scripts/services/transformer.js'
			'scripts/controllers.js'
		]
		styles: [
			'bower_components/fontawesome/css/font-awesome.min.css'
			'bower_components/pure/pure-min.css'
			'styles/style.css'
		]
		min: false
	}

	grunt.initConfig {
		pkg: grunt.file.readJSON 'package.json'
		vars: vars

		coffee: {
			main: {
				expand: true
				cwd: 'source'
				src: '**/*.coffee'
				dest: 'build'
				ext: '.js'
			}
		}

		connect: {
			main: {
				options: {
					base: 'build'
				}
			}
			min: {
				options: {
					port: 8001
					base: 'build-min'
				}
			}
		}

		copy: {
			main: {
				expand: true
				cwd: 'source'
				src: 'tests/the_raven/*'
				dest: 'build'
			}
			min: {
				expand: true
				cwd: 'source'
				src: 'tests/the_raven/*'
				dest: 'build-min'
			}
		}

		cssmin: {
			min: {
				files: {
					'build-min/styles.css': ('build/' + style for style in vars.styles)
				}
			}
		}

		jade: {
			main: {
				expand: true
				cwd: 'source'
				src: '**/*.jade'
				dest: 'build'
				ext: '.html'
				options: {
					data: vars
					pretty: true
				}
			}
			min: {
				expand: true
				cwd: 'source'
				src: '**/*.jade'
				dest: 'build-min'
				ext: '.html'
				options: {
					data: {
						scripts: vars.scripts
						styles: vars.styles
						min: true
					}
				}
			}
		}

		qunit: {
			main: {
				options: {
					urls: [ 'http://0.0.0.0:8000/tests.html' ]
				}
			}
		}

		stylus: {
			main: {
				expand: true
				cwd: 'source'
				src: '**/*.styl'
				dest: 'build'
				ext: '.css'
			}
		}

		uglify: {
			min: {
				files: {
					'build-min/scripts.js': ('build/' + script for script in vars.scripts)
				}
			}
		}

		watch: {
			main: {
				files: 'source/**/*'
				tasks: [ 'default' ]
			}
			min: {
				files: 'build/**/*'
				tasks: [ 'min' ]
			}
		}
	}

	grunt.loadNpmTasks('grunt-contrib-coffee');
	grunt.loadNpmTasks('grunt-contrib-connect');
	grunt.loadNpmTasks('grunt-contrib-copy');
	grunt.loadNpmTasks('grunt-contrib-cssmin');
	grunt.loadNpmTasks('grunt-contrib-jade');
	grunt.loadNpmTasks('grunt-contrib-qunit');
	grunt.loadNpmTasks('grunt-contrib-stylus');
	grunt.loadNpmTasks('grunt-contrib-uglify');
	grunt.loadNpmTasks('grunt-contrib-watch');

	grunt.registerTask 'default', [ 'copy:main', 'coffee', 'stylus', 'jade:main' ]
	grunt.registerTask 'min', [ 'jade:min', 'copy:min', 'uglify', 'cssmin' ]

	grunt.registerTask 'serve', [ 'default', 'min', 'connect', 'watch' ]
	grunt.registerTask 'test', [ 'default', 'connect:main', 'qunit' ]