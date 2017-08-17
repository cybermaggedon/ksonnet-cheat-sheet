
// Import KSonnet library
local k = import "ksonnet.beta.2/k.libsonnet";

// Specify the import objects that we need
local container = k.extensions.v1beta1.deployment.mixin.spec.template.spec.containersType;
local containerPort = container.portsType;
local depl = k.extensions.v1beta1.deployment;
local env = container.envType;

// Environment variables
local envs = [

    // List of Zookeepers.
    env.new("ZOOKEEPERS", "zk1,zk2,zk3")

];

// Ports used by deployments
local ports = [
    containerPort.newNamed("rest", 8080)
];

// Define containers
local containers = [
    container.new("gaffer", "gcr.io/trust-networks/gaffer:0.7.4b") +
	container.ports(ports) +
	container.env(envs) +
	container.mixin.resources.limits({
	    memory: "1G", cpu: "1.5"
	}) +
	container.mixin.resources.requests({
	    memory: "1G", cpu: "1.0"
	})
];

// Define deployment with 3 replicas
local deployment = 
    depl.new("gaffer", 3, containers, {app: "gaffer"});

local resources = [ deployment ];

// Return list of resources.
k.core.v1.list.new(resources)


