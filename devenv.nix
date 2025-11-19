{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:

{
  # NOTE: https://devenv.sh/basics/
  env = {
    PYTHONPATH = config.git.root;
    DJANGO_SETTINGS_MODULE = "todolist.settings";
  };

  # NOTE: https://devenv.sh/languages/
  languages.python = {
    enable = true;
    version = "3.12";
    venv.enable = true;
    uv = {
      enable = true;
      sync.enable = true;
    };
  };

  # NOTE: https://devenv.sh/services/
  services.postgres = {
    enable = true;
    package = pkgs.postgresql_17;
    listen_addresses = "localhost";
    port = 5432;
    initialDatabases = [
      {
        name = "todo";
        user = "todo";
        pass = "todo";
      }
    ];
  };

  # NOTE: https://devenv.sh/processes/
  # https://devenv.sh/reference/options/#processesnameprocess-compose
  # Ref:
  # - Process-compose Healthchecks: https://f1bonacc1.github.io/process-compose/health/
  # - Process-compose process states: https://f1bonacc1.github.io/process-compose/launcher/
  processes = {
    dbmigrate = {
      process-compose.depends_on.postgres.condition = "process_healthy";
      exec = ''
        django-admin makemigrations
        django-admin migrate
      '';
    };

    runserver = {
      process-compose.depends_on.dbmigrate.condition = "process_completed_successfully";
      exec = ''
        django-admin runserver
      '';
    };
  };

  # NOTE: https://devenv.sh/git-hooks/
  # https://devenv.sh/reference/options/#git-hookshooks
  git-hooks.hooks = {
    ruff.enable = true;
    ruff-format.enable = true;
    nixfmt.enable = true;
    prettier.enable = true;
  };
}
