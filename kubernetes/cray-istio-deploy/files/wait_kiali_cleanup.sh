
# MIT License
# (C) Copyright [2021] Hewlett Packard Enterprise Development LP
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.

# After the IstioOperator is updated to disable Kiali it takes a while before
# the Istio operator notices and cleans the Kiali deployment that it craeted.
# This script is run as a post-upgrade hook to wait for that cleanup to happen.
# If the objects were already cleaned up this script will exit quickly.

function check_istio_kiali_objects() {
  istio_kiali_objects="None"

  objs=$(kubectl get serviceaccount -l app=kiali,install.operator.istio.io/owning-resource-namespace=istio-system,install.operator.istio.io/owning-resource=cray-istio,operator.istio.io/component=AddonComponents,release=istio -n istio-system 2>&1)

  if [[ "${objs:0:18}" != "No resources found" ]]; then
    istio_kiali_objects="ServiceAccount"
  fi

  if [[ $istio_kiali_objects == "None" ]]; then
    objs=$(kubectl get clusterrole -l app=kiali,install.operator.istio.io/owning-resource-namespace=istio-system,install.operator.istio.io/owning-resource=cray-istio,operator.istio.io/component=AddonComponents,release=istio 2>&1)
    if [[ "${objs:0:18}" != "No resources found" ]]; then
      istio_kiali_objects="ClusterRole"
    fi
  fi

  if [[ $istio_kiali_objects == "None" ]]; then
    objs=$(kubectl get clusterrolebinding -l app=kiali,install.operator.istio.io/owning-resource-namespace=istio-system,install.operator.istio.io/owning-resource=cray-istio,operator.istio.io/component=AddonComponents,release=istio 2>&1)
    if [[ "${objs:0:18}" != "No resources found" ]]; then
      istio_kiali_objects="ClusterRoleBinding"
    fi
  fi

  if [[ $istio_kiali_objects == "None" ]]; then
    objs=$(kubectl get configmap -n istio-system -l app=kiali,install.operator.istio.io/owning-resource-namespace=istio-system,install.operator.istio.io/owning-resource=cray-istio,operator.istio.io/component=AddonComponents,release=istio 2>&1)
    if [[ "${objs:0:18}" != "No resources found" ]]; then
      istio_kiali_objects="ConfigMap"
    fi
  fi

  if [[ $istio_kiali_objects == "None" ]]; then
    objs=$(kubectl get deployment -n istio-system -l app=kiali,install.operator.istio.io/owning-resource-namespace=istio-system,install.operator.istio.io/owning-resource=cray-istio,operator.istio.io/component=AddonComponents,release=istio 2>&1)
    if [[ "${objs:0:18}" != "No resources found" ]]; then
      istio_kiali_objects="Deployment"
    fi
  fi

  if [[ $istio_kiali_objects == "None" ]]; then
    objs=$(kubectl get service -n istio-system -l app=kiali,install.operator.istio.io/owning-resource-namespace=istio-system,install.operator.istio.io/owning-resource=cray-istio,operator.istio.io/component=AddonComponents,release=istio 2>&1)
    if [[ "${objs:0:18}" != "No resources found" ]]; then
      istio_kiali_objects="Service"
    fi
  fi

}

check_istio_kiali_objects
if [[ $istio_kiali_objects == "None" ]]; then
  echo "No kiali objects created by the istio operator found."
else
  echo "Kiali objects created by the istio operator found, waiting for the istio-operator to clean up."

  while [ 1 ]; do
    sleep 5
    check_istio_kiali_objects
    if [[ $istio_kiali_objects == "None" ]]; then
      echo "No kiali objects created by the Istio operator found."
      break
    else
      echo "Kiali objects created by the Istio operator found ($istio_kiali_objects)"
    fi
  done
fi
