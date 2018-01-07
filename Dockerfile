FROM gcr.io/cloud-builders/gcloud

COPY kubectl.bash /builder/kubectl.bash
RUN chmod +x /builder/kubectl.bash
ENTRYPOINT ["/builder/kubectl.bash"]