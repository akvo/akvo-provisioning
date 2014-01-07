
class users {
    include users::groups

    include users::carl
    include users::root

    users::basic { 'oliver':
        roles    => ['ops', 'www-edit', 'reporting'],
        allow    => ['munin'],
        ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC0bMRyG8EspxOf7p2+sqWsTDq3RX6VnO65MWrp1SrCQhG6tMAsKeza82J2UuCN+GFTEO4yyO05s942UZ+5vgV+5CZ1Z6tlI7SFvovZM+fNSJn/BzQC8s1nAsVFMoAFKNNcLb7LS0rUhZ+RmDaCxIoH2TcbhxBVbynR41kbQfL1+oWnp3xmEeb/4/NKMaVYh3R/cxSe1GLlr19E/btywxzF4CGn5fNjkherrg7Bv7Mc7PmOezE7uwfbidGF0alYNOSPCKcI4t+kookD5XzP3sKPqVWCXjwSCrnuR/ViWKG1TxZtvIdKvRJwA7X7Y5eL1c9UruWtZio+Tyqa4u9obn9x',
        htpasswd => '$apr1$WdYFnpfb$nE14MA.Yra5q6K5MILDOO.'
    }

    users::basic { 'mark':
        roles    => ['developer'],
        allow    => ['munin'],
        ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDWClGycX1cV/MWmOZewiwPqv7Oev4znxOtN3FaVx1jxAHVqL0CC+pwm8vymKQ3oY4BxuHoKWnlEMV41YElOHKfBYRxVT3lzJPOK8531yobBaXcvmHYg2eHFYEn/dE4d0bVpbt6+9Q1uY5QZpqifPiLpf/xAKWOO3eccsgih7y3baqmMeU6XxBgcEt9ZI5Chqvm8bT/y026hvqhQhia0EKY5Wi/YFIVg39+fvCZpmKmHldusp9/9FkET+180Qt0IeOhG8FeqokoCYfI9W9wYQu+0N+zoKw3FMXYli1qarqF4RwpRiuiHAp44iGeE3z3+kiwRQW6ZDkP0m5oJDKhNXTB'
    }

    users::basic { 'gabriel':
        roles    => ['developer'],
        allow    => ['munin'],
        ssh_key  => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAtpiIHmcPNkjOJVEvTR6/1BJl7jk+mmaOCuZI+8u0nZKHxX2t58YZ+VPW3b+2JfjykKjE2k7ysq12Z9HOQX4mpUZcj3h3fTXkIplUG1v4c/ewNIZbyK1gwUNTUjtzIMaTCv1HDEnYQxkqhW6tFrOnxf8K1TO2iUUL3DeiQcuvaUd22OLUZhbiIukgnoX6R6CQdKkEP14WFPb4BAgu1iWR8afKmxn8Jw7YShHvvVZMdICXLFA93pIKctBSc2TmMVmMv9tRH3bvLQWDpAUN7UsM4JjuQMl+0K3vhJ+Y0+cGX2Rfh1eFT8XK6TuAxlwfMuSmM7sfIUGMy56VAtozrUHB0w==',
        htpasswd => '$apr1$DPt9tUH8$tAcbjLu6KBUw5WshJzHr91'
    }

    users::basic { 'loic':
        roles    => ['content', 'www-edit'],
        allow    => [],
        ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDMcxo84hJzUijPZpIOFWMlsm+7ECh+ap9KqkKcQG5rvJiDCtlSXyX5z3Vyw0D3Nc+TUc9uWA3oololWuxBHrVuv7r3WzdfYY7vfQ7byv5cyGrVV/VYW6AnlYa9zrglA3GjTXjCrLfCUedBO6s49sCAUeDBm9fM3N6R8FgAHYUbUXrsmgwGHWNkzZS/SpDjHVXyucVhJ2i1KgDpcLt6SHDxqPUbLES8/yEBfuRVDmJj1MQJSfUYQhGfyxiQCgFh30ADRscAp24laavYRxtGz5X/krKkOFnC23OHwoqkt/e+Fb9woC9J7PPaMwYKkJIlkZvdhLlVuTJRO7LaGJH5rPTV',
    }

    users::basic { 'lauri':
        roles    => ['content', 'www-edit'],
        allow    => [],
        ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDQck+Dwuj5gJ3d38/SXIVoMkjh407q6+6L0meWMLvfiSeKyBXt8HNeXg0c4+YnGz0ac0QoaA2rPY8JecMsKpW/utqhDFq3eXnZhVzbCLrft0sakaM+EMPeb+YQRmJZZhMUoPAvp0ZPfPgZz6tb1/F4m/IVE7c57oVWcm7HpgihBsZ+AEMZYP0zMcY0/EE0Hb2wyMwySJ0EO6DwyroT5xljsO3Gko1zTeFAdZ4F71JRURqw/micSwR47nAGLJukvLyWBf6cghdCXAgJ7Hfc4aIb5MiRqBSQHw9A/8qNIqMre0X/H3fCX+IwX+a/LgO8oay7KQ/SyjcJG3ZAj3MsMlF9',
    }

    users::basic { 'ivan':
        roles    => ['developer'],
        allow    => ['munin'],
        ssh_key  => 'AAAAB3NzaC1kc3MAAACBANzuaM/M9Xj2lxx8KvACWhXqfW4a00elyzZTYgMfK9LLmBS6MTkYkm2hP1vuU/o/1ocf52EVQPU27vrcslhlhHvec7y78b6xjl3MN77+tYbjZpQgTQfKfYtZoBcQwDbX6K0s9NfGALOR398Xa2zdDiRNKQ0ERETTY0vvVmd306lXAAAAFQDgqWJbZDp4BYecATtfwRll1hCozQAAAIEA2g00ovVLTFVNghzgiLvMKRdHDaoXVr1dBGGKfWX6KZe9uv6kuK0uQKUIoa1hiMVknFiegCnVIwy4tNdfDHBQibUFedWjRBMo8AbJZI9Ln84sYbE8+E9YgY/V1WudQhIazWjrgR/8Eq7wltxywSSO5BjM7ECwbcdjVU4Vv8/CuZIAAACAdkx8kthySQXoL4ZV3UeX219Aj7C3NRw2Is4WmdESDgfb0+ZFFys6ahowb8DfnUYBiDdFb9SEFH4pbqxo79aP3S6ZazcUSzx3CGv3+g+H/luTH2vGCfT/AAWN4fzmNFx8qVykunCltmGemH15SI8TczOW93ovpXDXf/T6VrmA8Wg=',
        ssh_type => 'ssh-dss',
        htpasswd => '$apr1$T.jIlS/U$3QmwUREyPTBJXfC9f6U8S.'
    }

    users::basic { 'adrian':
        roles    => ['reporting'],
        allow    => ['munin'],
        ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDJFUnZjY1PxF5mWYMjBO+y+Imk9fPxSHk1p03YT6L8NDb3XVs7rfPkvjXLZjH5ajT1Kv3YYtduHOmqdz73pxkJkrUyKzxPdzaLZxS/ZENZPagiBS70tHyxdqpsupibWP885WSEJ/DjWykeV5ebylwYL8IjctXZtbicOf5MpE+l4pyoUgi/KBs6J+CCS9/FZiPVSDQFEjcEY5We/7Rcu19k8PxWtuZIk4/E7yilzEazeegUj//35r+us08vhkrywLey4Wcz6/OH+JYvF63b4pNQ/B9isypgFHXA2DA8Wbmr6kkwocuiUUlNqVy0HiBUHtvbhTEYWsjYALFcVLAyMocl',
    }

    users::basic { 'annamarthe':
        roles    => ['test'],
        ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDVD9dXh/nxoZw4iUx1UAb1NxwILJ4zUjJs4vDEX+1v98a7mJZtt120s5f1FDqdlQQajZLfhl/eyQTvBmg8ho3BCiIcdZKxB1E9IICRULiDgzAMQVbi9DoDA+pp5KLS9t8OF66x7GwXxZkbqE8KYz1DtctlhXyeYM2J7whkEj8qixcqpsWOdKqRpGQtd6vPAt5+vgHTiCqAYhl41kgGeCl/9fjPYP98WxvqfXwec8WqVPAMGPKbMJ8irMLOGlfavBNrXg66tP4lrQGMTi+7FsOGuZZ+UgjWVmzDmb5BbHzfPgcrMWbB5/05+2PRX4ZO9cgbW5w3lp434w5aRp+8JiEl',
    }

    users::basic { 'ruarcc':
        roles    => ['test'],
        ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDtYfOFNyq2iP7cMNYuRt/QUlnX+z9fRlv+CBv0EypwYNpQ1ks8VPAb+dARXY0jwzq/KqU5UszqUKu8xF5w+ECec3uKnrMDgZ1UtIxjW+3KxiEqRTy8VMvfkrLDMMG0G2MZ+MxXKBLJL5OIj2b7xKi1oJcmoZ3QdbAzRU87te1AJ1sMS1fTgbW78jD8QaQ5Xi+bJXo1Jbn2fuOp2v0LdeeZ3EFXkFG8sEFiNTlcKDO8TVu4T9vXPOsrTUEKEicS73lvz6PL6RT3gkVpIEiSr2sQkVAGcfk+tYboEG1vMYv8tSUQGb7yvcCE2QHUhHI4RWxXm85Wv6SyBj0iLZrW/lQX'
    }

    users::basic { 'lynn':
        roles    => ['reporting'],
        ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDAoetrIBiu34tw/jD1OWlQ7fRPvMjvgmloE8Y+uaJ57Nf8qf3vgp7P7oiVs6FToApHZlVirs1ZNN8xFal0ZYV+3FyHaeZ8Y8eTnbJp/3sbY3ERNWFmMUqyfm/T/ZQ9NHyBLN3JVKtlUxTMSZ5dvjPRvUDwd/fszD8CjAXN6P8Kr94atcrOwUguXDzGcR+G+wZbAYwpnWbxxYVhmjHXQrgKnETCrxt6DExXqZh+5GTR/mCakB4x4yU4PCiVE/jAMvxBW1e4GXtk1mM3bTBDi3E5/5FX1OA8mVc3CPHV98up0NIGBGMRxXECdzjgILNHlzJBvluVORrgjxX5vK3UeMaP'
    }

    Class['Users::Groups'] -> Users::Basic<||>
}
