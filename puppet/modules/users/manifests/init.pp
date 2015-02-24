
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

    users::basic { 'oriol':
        roles    => ['ops', 'www-edit', 'reporting'],
        allow    => ['munin'],
        ssh_key  => 'AAAAB3NzaC1kc3MAAACBAM5O34uN5rzwJFdpktPtbMbfXOSXGB4x6aU1Zt0zq7cmlJ6YqmGe37OEZnG4IoMrUDPN1k6iP053Digms0QWtrJUVArxPQvQd/nM3FiB2g1n94wJt1I2r4Fe+9cboaQcUVXWMuJAlfewglFKq4B769qTzyOA3QS/30foKtGKe5EbAAAAFQCPGLIH728Hssbfu/sPLMCxXPu8WQAAAIEAtXvS0oKgl5s33svdeFf6uZsv6ApD4zZZ4gtu5XmJDKTjsXIAEUIGe12yZKDzIF/TnjKu92B6+GioIAKUPzJ7LLCzo9pcxjDgnqJfwhqsJIshBGOa8LA/BjSoJ3rJT1Oq5HaL0L42+hUh+bXs8wqy/TZ+lJLaMfvFuItPmtDLiKQAAACBAKWMyEuYAsO2mVcgNdaGmcodn2ePR0cJlIiuIxIC4uwDYjuDcuwqZb+ZeU9AQDn4wiE82i8MDvSLRTOUZTylxBJXq9lBDXzVH/avPoSUa0QXRlplz1zoz9UazuqJ61pDMiqN2GKkL/LJrUxHCDmN6Ugfyh7cMlE2TDnGktAKj78f'
    }

    users::basic { 'emmanuel':
        roles => ['developer'],
        ssh_key => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCltUhaWuIsw/ejItlKyCb/8fFA0g6Age19fX5y51WFFz2psgf3vcPvmw90TCEh4gH+Sz4c2AZ9c+lq60kFX5mgs1yS+jLCAYXvvhE8vGPR7il8f/AVbsDtv5o5pwFYq4MdMI9tpPwz60vrlu61mqpBRBmWNrlI7aiHwSnKRrLGCNPkvj6t4jA5WPdozv5DThjrEF0j8pu2bPzyz1nXIcijZWU4jVQtqfVxZ+gSIxpCiPwF9IQQnwPk+tRns6/DY+oo11Ug3csBDbyvlUgZg8Wj4O1ng/5x9b0xAeVzCY2+hP5f13Bhuy5CNlgl3YPYxIz78b5QnCCUjwjZKMl9u183'
    }

    users::basic { 'mark':
        roles    => ['developer'],
        allow    => ['munin'],
        ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDezghb+Fmk9rLjr0yr1bym1hCWgzU02pPbvSAX5dPjU2tK5d7vuoimLfLf7VVd7M/Mz0BQwMS75mkc1/lZuPJJnCsLsAxrq1Hj7HZW2p5kgxjY8tYTc/q7bgO88MP1FnOoN/zDy09hcPdPAgooNNrFz3LiE2FPx3UsPjxjO40rLcsb2tKYe5oP5wDU0D4E2/8qhQIOb+qGU08+aMEXnoVuexq6RNFKWNM0kVpLB3kJ2i1AsrrsgdrOFMLSd6zCCFlFP4NYwyO/U3K39VPg0sFC2BtSayqCQbtef9w/E2ziNki7yLkNOHNoiROUcMxJV3Ca19olC5dafIiQWrOf9H5Z'
    }

    users::basic { 'gabriel':
        roles    => ['developer'],
        allow    => ['munin'],
        ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDiyba8p2OCX4T2/8sOQ3WeJZiTXm7TS+INlmsmwarVpLRh7lUAnb+DdCRFDGd7ZxhJSDNqPpr6dSyjW0703GcwLbaaP3ErngzaHCZTGuw7o82RV6MYul/jpiungm04NNoz3PeNUAwM5MlSXOW6WGjKwZ29khnjMfQWBhSE4XnR1lu0uSMPKHzT10UtvBEAlEi/QKEstfIzZmcp0/DObVt+yD81hGT5O8RyhEa9A7JchETdDjffBSo+fiVu9NkiLJXlPSLgtbztv6Ap+B/UkqQWREPWrdWwz18p2AJd45Q7DtjH7dh2UnVt4+4XKBMrjwCAN6DR/hxnwQFkzi4siWED',
        htpasswd => '$apr1$DPt9tUH8$tAcbjLu6KBUw5WshJzHr91'
    }

    users::basic { 'kasper':
        roles    => ['developer'],
        ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC38uhU4OymVsasod6HdXkIzhgAea8qzFMxTP8Gv3NB2oGlUWTTjNqnI9AZ6pa4Vq3whOjFqx+3L7q7OKnEARUgbJFuGYXbtOrAFWKJxvAciu5CoRw/tUTJaagHVRDWUHLkMD55EioQ2XeXPXrPzZGzc2QARCPIs0rp61jg+bLjbpWeYtiFUHc+HxACnEV/NhkZQ1RlRiO+BS2ngLc0xVlYRSfMxiza7GXcxznLIsb6NjM9YeqEzHcbdFXBVS+b0x8BLaeG0HKzpO4M1J+FBS6Jdvtp9AXOGd9LT+v+fDJiP8XVxwWW5Pa8b5QGe7pUaGsiiFC+tliRlOOjfxzdxpJB',
    }

    users::basic { 'stellan':
        roles    => ['developer'],
        allow    => ['munin'],
        ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAAAgQDE+s/CSGkvynr/7nWe7/9Vkv2Nv6m84HTruEo9yN5vpvDp5j6XpsNklq9NgLYQs8/C46iKvbFTF/apIauHCr1lC27PI0m2n5coUNbNGoJZMhWoq4LmHdbhu4vhDgz+Vqx0hbQrNHiG7XIhsaqFnCJua8faKJUn6RKTantQr5aQDQ==',
    }

    users::basic { 'loic':
        roles    => ['content', 'www-edit'],
        allow    => [],
        ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDCryjqHYO3dyI0uQn1jEioe/e/OM9SeOkaTXGgQJKA8OVn5CIyuXUf2PYpShU54VZ1zwJEKWcNHDCxzwdqU7z8rTHRxzcTUAlsz2R/HTkHtg9hsUbu5IuO8xUYt7G8yuAVyVOAgOIM29Vj9MbbAgz/es8cAAfQaQ5G/EHkKvZAd/ZwQYsX6n6yG9SI+hXUH7DmNefEEzaJdLtpQ/iySNuKEwdPgC31w31HNiz/ByJXy32S1hXzo+kXdvp5LzTQka+VUkkcPliT+yGH7XInEiFQZKzyrtc71YmO0dcJyUYb6IwOc7KGaFvZVty0oPcu5Elu7XOWtMbHkfRcEauURu71',
    }

    users::basic { 'gabe':
        roles    => ['content', 'developer', 'www-edit'],
        allow    => ['munin'],
        ssh_key  => 'AAAAB3NzaC1yc2EAAAABJQAAAQEApKMrguIMU42MV6Ia6s7658348kEDqKAUV84u/d4o+hwkIXX07JE/Z8+3Pvno7tsBGqCzmI6P5WbCn3e14g65paXctWCq8MrQIOdc3UsDeiDd9o9SSp1Z/1y2nYKV77ZAtB7sBH+ht95u9JoTpgS1ghkBVlY1PIzjaqfRPIF/JjxEszjxtSztMDvmENpEAlvz9upvwML7SgPOIkjGlq3FHcXuIz4tSL0iMWdJ/0GP7LuiaXXdnpS48qOLnE6KhZBEMTTHJWR4T/U0XGtESZxe41/fBRBcuesoacJh+eKxhZ5tfmeFmYA4L39pQUjNd8lo2rFmiaSEdo2h5DZ1+DCRNQ==',
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
        roles    => ['reporting', 'www-edit'],
        ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDAoetrIBiu34tw/jD1OWlQ7fRPvMjvgmloE8Y+uaJ57Nf8qf3vgp7P7oiVs6FToApHZlVirs1ZNN8xFal0ZYV+3FyHaeZ8Y8eTnbJp/3sbY3ERNWFmMUqyfm/T/ZQ9NHyBLN3JVKtlUxTMSZ5dvjPRvUDwd/fszD8CjAXN6P8Kr94atcrOwUguXDzGcR+G+wZbAYwpnWbxxYVhmjHXQrgKnETCrxt6DExXqZh+5GTR/mCakB4x4yU4PCiVE/jAMvxBW1e4GXtk1mM3bTBDi3E5/5FX1OA8mVc3CPHV98up0NIGBGMRxXECdzjgILNHlzJBvluVORrgjxX5vK3UeMaP'
    }

    users::basic { 'daniel':
        roles   => ['developer'],
        ssh_key => 'AAAAB3NzaC1yc2EAAAADAQABAAACAQCrVmb9hJRUHrdSxSWWsrg7palgPkM8koG/2Br+riRY1tCCLYpORhAEWqHdVeHJL65ka27l5ICp0P0zQuhtE7s8WOLah/ygDlce8GjtBQNoR4/X7jkF+Citxeo3g1wJuExem3hbg5AB502yeIUa7mVXM94KC2vKxFVOrMn8IGITS7F7Uxy5uQsgOv54H0wS2HyVzyW5F0H1pW6IrSQyaSjlGBu3ZCpJwshE/5cg1xrlwWFcc99MvTZTAPCFILpLNWkxgtZCuzK9prEYKnDZJWI4eG5L8jR98rieihExW/6HOu3XlwAdBybC0bDBFlKqUBAKY/b5naXhsEevFOk7AC1c9GhJSfUlmkO7TUZTGCv05OTZ93YOieWXWAi6wniGqT7iauSf2Nw9tNRKa56mwom85MRtjWq7rj5q7veWOu8dGFZArSOY1WVzYwH6tS8PiZ5HSfOTY4LL+atu5mi2n81yc8bT8+hf+uY1zlbQQ/TxN0hH/jWSCHMuJIOz4F3eJ/Q8mbobJFPXegF2Figy9UI//aFcNcsLVr1ah34uWcSP7k2+XGK6UzHDxNJpR5xmkUfdLWNd7nJdelnmBC+4jNOduNx7KPCNpET7H3wjjS9G7+hUYBboe1yFnkZlQuCLsEqcfZYT5ETBaJ4zdaFVcJXOTn56cmPO5f/xKm5cv2gxFw=='
    }

    # removed users
    users::remove_user { ['paul']: }
    users::remove_user { ['neha']: }
    users::remove_user { ['lauri']: }
    users::remove_user { ['dan']: }

    Class['Users::Groups'] -> Users::Basic<||>
}
