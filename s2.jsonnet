
// Import KSonnet library
local k = import "ksonnet.beta.2/k.libsonnet";

// Specify the import objects that we need
local container = k.extensions.v1beta1.deployment.mixin.spec.template.spec.containersType;
local depl = k.extensions.v1beta1.deployment;
local env = container.envType;

// Environment variables
local envs = [

    // List of Zookeepers.
    env.new("ZOOKEEPERS", "zk1,zk2,zk3")

];

// Define containers
local containers = [
      container.new("gaffer", "gcr.io/trust-networks/gaffer:0.7.4b") +
      container.env(envs)
];

// Define deployment with 3 replicas
local deployment = 
    depl.new("gaffer", 3, containers, {app: "gaffer"});

local resources = [ deployment ];

// Return list of resources.
k.core.v1.list.new(resources)


