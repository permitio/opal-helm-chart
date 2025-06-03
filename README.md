<p  align="center">
 <img src="https://i.ibb.co/BGVBmMK/opal.png" height=100 alt="opal" border="0" />
</p>
<h2 align="center">
OPAL Helm Chart for Kubernetes
</h2>

OPAL is an administration layer for Open Policy Agent (OPA), detecting changes to both policy and policy data in realtime and pushing live updates to your agents.

OPAL brings open-policy up to the speed needed by live applications. As your application state changes (whether it's via your APIs, DBs, git, S3 or 3rd-party SaaS services), OPAL will make sure your services are always in sync with the authorization data and policy they need (and only those they need).

[Check out OPAL main repo here.](https://github.com/permitio/opal)

### Installation

OPAL Helm chart could be installed only with [Helm 3](https://helm.sh/docs/).
The chart is published to public Helm repository, [hosted on GitHub itself](https://permitio.github.io/opal-helm-chart/). It's recommended to install OPAL into a dedicated namespace.

Add Helm repository

```
helm repo add permitio https://permitio.github.io/opal-helm-chart
helm repo update
```

Install the latest version

```
helm install --create-namespace -n opal-ns opal permitio/opal
```

Search for all available versions

```
helm search repo opal --versions
```

### Deploy OPAL to your Kubernetes cluster

Install specific version (with default configuration):

```
helm install --create-namespace -n opal-ns --version x.x.x opal permitio/opal
```

Install specific version (with custom configuration provided as YAML):

```
helm install -f myvalues.yaml --create-namespace -n opal-ns --version x.x.x opal permitio/opal
```

`myvalues.yaml` must conform to the [json schema](https://raw.githubusercontent.com/permitio/opal-helm-chart/master/values.schema.json).

### Verify installation

OPAL Client should populate embedded OPA instance with polices and data from configured Git repository.
To validate it - one could create port-forwarding to OPAL client Pod. Port 8181 is the embedded OPA agent.

```
kubectl port-forward -n opal-ns service/opal-client 8181:8181
```

Then, open http://localhost:8181/v1/data/ in your browser to check OPA data document state.

### Important Configuration

This is not a comprehensive list, but includes the main variables you have to think about

| Variable                                       | Description                                                                                                                                      |
| ---------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| `server.policyRepoUrl`                         | Git repository holding policy code (& optionally policy data) to be tracked by OPAL                                                              |
| `server.policyRepoMainBranch`                  | sets OPAL_POLICY_REPO_MAIN_BRANCH which defaults to `master`                                                                                     |
| `server.dataConfigSources`                     | Data sources to be published to clients (and their managed OPAs)                                                                                 |
| `server.dataConfigSources.config.entries`      | Static list of data source entries (See [OPAL Docs](https://docs.opal.ac/getting-started/running-opal/run-opal-server/data-sources))             |
| `server.dataConfigSources.external_source_url` | URL to dynamically fetch data sources entries from (See [OPAL Docs](https://docs.opal.ac/tutorials/configure_external_data_sources))             |
| `server.broadcastUri`                          | Backend for broadcasting updates across multiple opal-server processes (necessary if either `server.uvicornWorkers` or `server.replicas` is > 1) |
| `server.uvicornWorkers`                        | Count of gunicorn workers (/processes) per opal-server replica                                                                                   |
| `server.replicas`                              | opal-server's deployment replica count                                                                                                           |
| `server.extraEnv`                              | Extra configuration for opal-server (see [OPAL Docs](https://docs.opal.ac/tutorials/configure_opal))                                             |
| `client.extraEnv`                              | Extra configuration for opal-server [OPAL Docs](https://docs.opal.ac/tutorials/configure_opal)                                                   |

**Note:** If you leave `server.dataConfigSources` with no entries - The chart would automatically set `OPAL_DATA_UPDATER_ENABLED: False` in `client.extraEnv` so client won't report an unhealthy state.
