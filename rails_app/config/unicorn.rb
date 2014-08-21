worker_processes 2
timeout 15

listen 3000

stderr_path "log/unicorn.stderr.log"
stdout_path "log/unicorn.stdout.log"

preload_app true
