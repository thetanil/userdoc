FROM jupyterhub/jupyterhub:latest

# Install JupyterHub and other dependencies
RUN pip install jupyterhub jupyterlab

# Copy JupyterHub configuration
COPY jupyterhub_config.py /srv/jupyterhub/jupyterhub_config.py

# Expose port
EXPOSE 8000

CMD ["jupyterhub"]