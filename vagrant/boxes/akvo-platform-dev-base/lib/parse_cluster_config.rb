# based on https://github.com/tayzlor/vagrant-puppet-mesosphere/blob/master/cluster/lib/gen_node_configs.rb
# -*- mode: ruby -*-
# vi: set ft=ruby :

def parse_cluster_config(cluster_yml)
    master_n = cluster_yml['master_n']
    master_mem = cluster_yml['master_mem']
    master_cpus = cluster_yml['master_cpus']
    master_ipbase = cluster_yml['master_ipbase']
    slave_n = cluster_yml['slave_n']
    slave_mem = cluster_yml['slave_mem']
    slave_cpus = cluster_yml['slave_cpus']
    slave_ipbase = cluster_yml['slave_ipbase']

    master_infos = (1..master_n).map do |i|
                     { :hostname => "master#{i}.localdev.akvo.org",
                       :name => "master#{i}",
                       :ip => master_ipbase + "#{100+i}",
                       :mem => master_mem,
                       :cpus => master_cpus,
                     }
                   end
    slave_infos = (1..slave_n).map do |i|
                     { :hostname => "slave#{i}.localdev.akvo.org",
                       :name => "slave#{i}",
                       :ip => slave_ipbase + "#{200+i}",
                       :mem => slave_mem,
                       :cpus => slave_cpus,
                     }
                   end

    return { :master => master_infos, :slave => slave_infos }
end
