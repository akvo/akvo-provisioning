
class users {
    include users::groups

    include users::carl
    include users::root

    users::basic { 'paul':
        role     => ['developer'],
        ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDHS7Q2Qv/ynGVmoMgqBDoqsj6WXN1IoP2XdfVjdZ+mGdT5zBSvbQZklL55eisKgmnqxb7aXV2LVOVhrrlJTTh6nAWEBsxkXaDr9tS2VedV6MYbmv3bEjJIu4QvIZY1F5rzwFTcTUghem1fQUEzWibSof99F3rUwDDOBMJZZ2GVhYIDy7ottObtOt3KvTUV+V37Y+xaZzwo4Y0YwRygk48IdLAa4pr4SAxDTFyUfWazxxn6SAc4F5On2Zx1GcuFb3AKgz7tVTXe6WC+7KIrOwkSjdx9eAmgKxhUk2e/Ic9XjcalKV3LqRbHFq05iDKkoiC4ASMBiLnVdPz1Tc87mqwT'
    }

    users::basic { 'oliver':
        role     => ['ops'],
        sshkey   => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC0bMRyG8EspxOf7p2+sqWsTDq3RX6VnO65MWrp1SrCQhG6tMAsKeza82J2UuCN+GFTEO4yyO05s942UZ+5vgV+5CZ1Z6tlI7SFvovZM+fNSJn/BzQC8s1nAsVFMoAFKNNcLb7LS0rUhZ+RmDaCxIoH2TcbhxBVbynR41kbQfL1+oWnp3xmEeb/4/NKMaVYh3R/cxSe1GLlr19E/btywxzF4CGn5fNjkherrg7Bv7Mc7PmOezE7uwfbidGF0alYNOSPCKcI4t+kookD5XzP3sKPqVWCXjwSCrnuR/ViWKG1TxZtvIdKvRJwA7X7Y5eL1c9UruWtZio+Tyqa4u9obn9x',
        htpasswd => '$apr1$WdYFnpfb$nE14MA.Yra5q6K5MILDOO.'
    }


    Class['Users::Groups'] -> Users::Basic<||>
}
