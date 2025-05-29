kubectl apply -f https://raw.githubusercontent.com/istio/istio/1.25.3/samples/addons/jaeger.yaml
kubectl label namespace default istio-injection=enabled