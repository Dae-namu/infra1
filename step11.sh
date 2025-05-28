terraform apply --auto-approve -target=kubernetes_deployment.drama \
                -target=kubernetes_service.drama \
                -target=kubernetes_deployment.episode \
                -target=kubernetes_service.episode \
                -target=kubernetes_deployment.stream \
                -target=kubernetes_service.stream
