#!/bin/sh

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

# When upgrading from Istio 1.7 to 1.8 we need to clean up the add-ons because
# the istio-operator doesn't do it for us.
# I got these objects by disabling each AddOn in the IstioOperator and then
# watching the istio-operator log to see what it said it deleted.

set -x

kubectl delete PeerAuthentication -n istio-system -l install.operator.istio.io/owning-resource-namespace=istio-system,install.operator.istio.io/owning-resource=cray-istio,istio.io/rev=default,operator.istio.io/component=AddonComponents,operator.istio.io/managed=Reconcile,release=istio

kubectl delete Services -n istio-system -l install.operator.istio.io/owning-resource-namespace=istio-system,install.operator.istio.io/owning-resource=cray-istio,istio.io/rev=default,operator.istio.io/component=AddonComponents,operator.istio.io/managed=Reconcile,release=istio

kubectl delete Deployment -n istio-system -l install.operator.istio.io/owning-resource-namespace=istio-system,install.operator.istio.io/owning-resource=cray-istio,istio.io/rev=default,operator.istio.io/component=AddonComponents,operator.istio.io/managed=Reconcile,release=istio

kubectl delete ClusterRoleBinding -l install.operator.istio.io/owning-resource-namespace=istio-system,install.operator.istio.io/owning-resource=cray-istio,istio.io/rev=default,operator.istio.io/component=AddonComponents,operator.istio.io/managed=Reconcile,release=istio

kubectl delete ClusterRole -l install.operator.istio.io/owning-resource-namespace=istio-system,install.operator.istio.io/owning-resource=cray-istio,istio.io/rev=default,operator.istio.io/component=AddonComponents,operator.istio.io/managed=Reconcile,release=istio

kubectl delete ServiceAccount -n istio-system -l install.operator.istio.io/owning-resource-namespace=istio-system,install.operator.istio.io/owning-resource=cray-istio,istio.io/rev=default,operator.istio.io/component=AddonComponents,operator.istio.io/managed=Reconcile,release=istio

kubectl delete ConfigMap -n istio-system -l install.operator.istio.io/owning-resource-namespace=istio-system,install.operator.istio.io/owning-resource=cray-istio,istio.io/rev=default,operator.istio.io/component=AddonComponents,operator.istio.io/managed=Reconcile,release=istio
