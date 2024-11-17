# jupyterhub_config.py

c = get_config()

# Set the JupyterHub IP and port
c.JupyterHub.ip = '0.0.0.0'
c.JupyterHub.port = 8000

# Use the default authenticator and spawner
c.JupyterHub.authenticator_class = 'jupyterhub.auth.PAMAuthenticator'
c.JupyterHub.spawner_class = 'jupyterhub.spawner.LocalProcessSpawner'

# Configure the JupyterHub log level
c.JupyterHub.log_level = 'DEBUG'

# Set the default URL for users
c.Spawner.default_url = '/lab'

# Configure the admin users
c.Authenticator.admin_users = {'admin'}

# Configure the user whitelist
c.Authenticator.whitelist = {'user', 'user2'}
