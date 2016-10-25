# frozen_string_literal: true

module ApiSampler
  # Create an initializer with description of configuration and defaults. Mount
  #  **api_sampler** at `MOUNT_PATH` (specified with `--mount-at` option,
  #  defaults to `/api_sampler`). Copy and run migrations unless `--no-migrate`
  #  flag is given.
  #
  #  Run the following command for more details:
  #
  #  ``` bash
  #  $ rails generate api_sampler:install --help
  #  ```
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    class_option :migrate, type: :boolean, default: true,
                           desc: 'Copy and run migrations'
    class_option :mount_at, type: :string, default: '/api_sampler',
                            desc: 'Mount point of api_sampler',
                            banner: 'MOUNT_PATH'

    # Create an initializer with description of configuration and defaults.
    # @return [void]
    def create_initializer
      copy_file 'api_sampler.rb', 'config/initializers/api_sampler.rb'
    end

    # Mount {Engine} to `--mount-at`.
    # @return [void]
    def mount_engine
      route "mount ApiSampler::Engine, at: #{options.mount_at.inspect}"
    end

    # Copy and run migrations unless `--no-migrate` flag is given.
    # @return [void]
    def migrate
      return unless options.migrate?

      rake 'api_sampler:install:migrations'
      rake 'db:migrate SCOPE=api_sampler'
    end

    # Display notes after installation.
    # @return [void]
    def display_notes           # rubocop:disable Metrics/MethodLength
      log <<-NOTES.strip_heredoc

        Congratulations! api_sampler is now installed. What to do next?

        - Change the default mount point of api_sampler at `config/routes.rb'.
        - Inspect and edit the default config at `config/initializers/api_sampler.rb'.
      NOTES

      log <<-NOTES.strip_heredoc unless options.migrate?
        - Copy and run api_sampler migrations by executing the following commands:

            $ bundle exec rails api_sampler:install:migrations
            $ bundle exec rails db:migrate SCOPE=api_sampler
      NOTES

      log <<-NOTES.strip_heredoc

        Note: you can always undo api_sampler migrations by running this command:

            $ bundle exec rails db:migrate SCOPE=api_sampler VERSION=0
      NOTES
    end
  end
end
