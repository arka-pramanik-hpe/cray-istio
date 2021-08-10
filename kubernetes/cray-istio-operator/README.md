
This deploys the Istio operator. There are instructions here:
https://istio.io/v1.7/docs/setup/install/operator/

The istio-operator chart in the charts/ directory was copied (and modified -- see
details below) from the istio release which is available for download at
https://github.com/istio/istio/releases/ .
The chart is in `manifests/charts/istio-operator`.

# Changes from upstream chart:

In order to support pod priorities the deployment.yaml and values.yaml files
have been modified from upstream to support a priorityClassName.

# Recreate IstioOperator CRD on upgrade

When upgrading from the 1.6 istio-operator chart to 1.7 Helm winds up deleting
the IstioOperator CRD. The workaround is to have a post-upgrade hook that
checks for the condition and runs kubectl apply to recreate the
IstioOperator CRD.

This can probably be removed in the next Istio upgrade.

