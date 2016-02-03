
class users {
    include users::groups
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
        ssh_key  => 'AAAAB3NzaC1kc3MAAACBAM5O34uN5rzwJFdpktPtbMbfXOSXGB4x6aU1Zt0zq7cmlJ6YqmGe37OEZnG4IoMrUDPN1k6iP053Digms0QWtrJUVArxPQvQd/nM3FiB2g1n94wJt1I2r4Fe+9cboaQcUVXWMuJAlfewglFKq4B769qTzyOA3QS/30foKtGKe5EbAAAAFQCPGLIH728Hssbfu/sPLMCxXPu8WQAAAIEAtXvS0oKgl5s33svdeFf6uZsv6ApD4zZZ4gtu5XmJDKTjsXIAEUIGe12yZKDzIF/TnjKu92B6+GioIAKUPzJ7LLCzo9pcxjDgnqJfwhqsJIshBGOa8LA/BjSoJ3rJT1Oq5HaL0L42+hUh+bXs8wqy/TZ+lJLaMfvFuItPmtDLiKQAAACBAKWMyEuYAsO2mVcgNdaGmcodn2ePR0cJlIiuIxIC4uwDYjuDcuwqZb+ZeU9AQDn4wiE82i8MDvSLRTOUZTylxBJXq9lBDXzVH/avPoSUa0QXRlplz1zoz9UazuqJ61pDMiqN2GKkL/LJrUxHCDmN6Ugfyh7cMlE2TDnGktAKj78f',
        ssh_type => 'ssh-dss'
    }

    users::basic { 'emmanuel':
        roles => ['developer'],
        ssh_key => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCltUhaWuIsw/ejItlKyCb/8fFA0g6Age19fX5y51WFFz2psgf3vcPvmw90TCEh4gH+Sz4c2AZ9c+lq60kFX5mgs1yS+jLCAYXvvhE8vGPR7il8f/AVbsDtv5o5pwFYq4MdMI9tpPwz60vrlu61mqpBRBmWNrlI7aiHwSnKRrLGCNPkvj6t4jA5WPdozv5DThjrEF0j8pu2bPzyz1nXIcijZWU4jVQtqfVxZ+gSIxpCiPwF9IQQnwPk+tRns6/DY+oo11Ug3csBDbyvlUgZg8Wj4O1ng/5x9b0xAeVzCY2+hP5f13Bhuy5CNlgl3YPYxIz78b5QnCCUjwjZKMl9u183'
    }

    users::basic { 'jonas':
        roles => ['developer'],
        ssh_key => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC/zz7v3//7mZLImNHsCzv1bgm8zhJqziNYY21/2+qJwNMiVs8GR4hLPhfeZCAiJShgM2h0+JV5zpIZMMQTOvy3Hl8xLi/v6z58tioLspaIgTiV2gUjGT5LxYULJZTOb8kP9BFAFB64Q69zBCFPEhJW3fI11VKUjEChAtqxxjLn6ehEDTCjtp7f+tWmQtrEfWY4j2e2tiTWcvn9Ua+RSkhQISysRgAFo+bze/bwaY8Awv6RpksGT81RuTKJRtQvtmRwMNHvtOrupoSQhj7qhXkbgQwH1Qs9Vmnv4SJnGkHsEclWqyjFbNPfHAlnGgf3TF9dPtExK1vQZpK76cTLjSYB'
    }

    users::basic { 'mark':
        roles    => ['developer'],
        allow    => ['munin'],
        ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAACAQDDhn8XgGBSfF300qbXkadmpN8jpOoYlCuWcsp69hjmRYNdyJE3x1m1ES1zgmHJ7AwRvvExoCYbd/SsGdBMOobb1XBIUm0LBlPiddPNuDoK3TlaSbYhtKB2H2oEpsyRn/zejUmTRSlKdfM2lwPTh8f534S5L8R7hEwtXRCGNcPxODFOjPu6HXI2LSUk8U0CDAx4jFhVbX6IIgvY6XZh0mOWTUxrCasamfqBvnxCCrsuRi8gkizqL1e9YEEWezG/CKwcM3UD8riJ/wVTqav0kzApiEiAu4d1cNl0WuV6HjGCBOxp/lLOr1yHNMSSDqS98XykS+e7nLS/+WyMcFKz9TpenCcsiNP12Uf/lc1+D7dPzRk6QmXzs435LZzYw94mdlaWgi8RMo6St18iJRrhuEDFpNHRjkENYO8/jAvAtU38/iDt6z9cDEE7UV3q4Tyz0Bnp/txpXhz9JbTulJtdrl2aAQpCh+qxFKmN7HNctduxhQRuHMfWYFck+gEdjeKGwX3NiBTMoD0mwgbchJ+2rx0ZcXKsPByX0oHSQtqYPaGN/0F3TwdeeyjFGr4aJxhuZTCyJPGsw9vrT33KdOZr7MF2uqCvtanX2yiwD4k4/5FnZ0JtYbho3eGUQAfVgPJ0UJp0UTZN7tyML0ONbOXV1XaZiZg2pRNLCSVCkoPG08k3dw=='
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
        ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCrA0k73U1FL1YO1Q03eIN6ZBpOxJt+nkOyoQFDsvyVX2ETUIrQozVxKtFhvK/p5d3EgwJvdbSmMNCa85UP0xZRqC4YD/nDg0ZiakscXAmA5i8fHDDROl+XAVUA9Bz4lTDNZ6Iz4dH/s3+DNikOi12CpvDPSIlr78+UHaBEpmsIGFkVPXQc38PF4QUKoPQqnom86OrJxv2Bo79RWge4hquuBEQ/iOCJTIXwRm4AZkrgyVgTRJJ1gCIQrLsFKaT9aFOZiC8KrM6hf2KW4X9gzDip9TmaHuGxPypRZe7agN5DsITU0jx4E3itn/Z8ZXP3Jg+Daruvbaotqgpc0U+sbXIr',
    }

    users::basic { 'loic':
        roles    => ['content', 'www-edit'],
        allow    => [],
        ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDCryjqHYO3dyI0uQn1jEioe/e/OM9SeOkaTXGgQJKA8OVn5CIyuXUf2PYpShU54VZ1zwJEKWcNHDCxzwdqU7z8rTHRxzcTUAlsz2R/HTkHtg9hsUbu5IuO8xUYt7G8yuAVyVOAgOIM29Vj9MbbAgz/es8cAAfQaQ5G/EHkKvZAd/ZwQYsX6n6yG9SI+hXUH7DmNefEEzaJdLtpQ/iySNuKEwdPgC31w31HNiz/ByJXy32S1hXzo+kXdvp5LzTQka+VUkkcPliT+yGH7XInEiFQZKzyrtc71YmO0dcJyUYb6IwOc7KGaFvZVty0oPcu5Elu7XOWtMbHkfRcEauURu71',
    }

    users::basic { 'gabe':
        roles    => ['content', 'developer', 'www-edit'],
        allow    => ['munin'],
        ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDmkTDIokLfzaeGdqyOlXekl5fY9Fa+AtNaS7lpnwOSVr+dbzr7lJebcb2nwes4aZ+gWtItkyYOFQ+kB9X/EKIApOH3DuFZWDzSDbo6hS9Qv5ExYCzwhVLxjaqr/f32BjZB9HG6DyGJoplJfCKt7wObc6E5smbPRpqfEVfzpimbFTpLFNY8J534k49s1pLQiZBsyenXdqFrWTQ7GK+a3DBLaTpoZksPpVNk/r3mKfAqhSTMu9DXoX2qoBIDvrJpyhjgYQkwIO7qcPIOIx1Vl93KNYP0+6sH0/zo5JQZoX0Mmidjp1ErokA17IS8byhL855fqYxaoNviMYauKQ3BPNYN',
    }

    users::basic { 'ivan':
        roles    => ['developer'],
        allow    => ['munin'],
        ssh_key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCb4zzpiWZA6Fks06WDYtVGENyJS4HBdoV3X6FjPmUiOG+R7nRo1dD+S5Zapz0itM+f4gal3HDX8w4IRYX5ngRWb/cpx9kjFa6rimZPan8WJ4rlreZqMdoIT0bxWQawbYU7120CshnmRRN07pOFtwfsaNn5+o1dE/P0qGTldBjDqOJLWCeFCBQKTsqQbLBGT4Ands0ilAE21WxCSEXQhS4MzlZbTCSM07MB2goTdGLiku6NLRrPt5FQcb4LvqnYJI3THwAO7vgoKR0xZEpxiOJNgN/fQ+bO13F6ulCTXTPpCncZji5p9nZnfwi4v0LHHmeGkFtrznibJ+ZM5YZQscvX',
        htpasswd => '$apr1$T.jIlS/U$3QmwUREyPTBJXfC9f6U8S.'
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

    users::basic { 'joyg':
        roles   => ['developer'],
        ssh_key => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC2X+b3EO7GqnVX4YaqFBDx9s/Axx4KLMffbtkoenB3gh2fZxWQt7RaeRsGTsL92k7UrFPoODBLIjGXAgNp3tCvHqaSHg11PUSPD5IZRIgBPORo8opBl+RALEpi+O4BTDXsVQjrc9tXSbOEHZK3oIbk2u77Q9t1iv6kH1YjJf0CaFaTpkD5dOaRlMTeKmu9yn3SyNQejCiHxrgKz/AmIjfrqEw+0Pj4XALKd7KgGBl7gDS0D0e3SP7b8i5Fy8xIMl4OPz4ZXCGDVVipnniNH1h9WpjK0Uos2aE/EhwARzawwZJ74JlhAT4OeG68E/cbzNzO+c4gp61gQ1auJ2Dgq/hD'
    }
    
    users::basic { 'paul':
        roles   => ['ops', 'www-edit', 'reporting'],
        allow   => ['munin'],
        ssh_key => 'AAAAB3NzaC1yc2EAAAADAQABAAACAQDK+w4WN5fTuocEPCfl5f3H20KvcyLK/QNhDTsV9f4J3umEgvaYfD34ygIOGY0DCQEBfJ1qwxCWhxEEdqwWRD/onn9rriP3ec7jh/M3rvObfnzTq95hMNz4TC2KZSQ3DKE/MBtFretWTMNhJkOzlekWc1waLXVtSAqz68stqGjMvhLcwOX5pVk6vsTf22EoZkfUXMsNUYxrQfm1ZWeIpRiKlF+FD2gF3u7k6pyXoanhINyYOs62HGgq0uzCS4r1wcGPhKg5soBdATODF19CDcVz912ihsz+f9ozplJuro7l24jKB3lFTwrmDWOX/CH9q9D1vBaLRpgJ/5/1DN6J/Q0JhXVCI6GrTbWKQT8T/mV8TBkaaIrZbDwxErGb1/ZWOEFi4GS0giOfm0B/cg/nbJvUdrBzQx1zqmeO6BDjeHK4NzmnOSCsMopqtg81LRuHaODAVcDpLNQBkmj43NFPifz/yyuqajIyx+6/0d5arJ4cVJKE3+0JxTMfo8+gN5QsQlzYPPkrixun4hdZ79Vrhme4E/n/vZogaTxy0am2qH5kF4pbY7Vb766HLKKCerjR9ib/yyhhVXoC32G6IUjqwAIVN5oDLuj7Orgu9FvHeTjUeIe/MpSz8svfEPh+hbjZ6I7KogfmhrhiCZg2AUw+tTd2UqEsb9RqYjVHCb+S6s1kRQ=='
    }

    users::basic { 'andreas':
        roles   => ['developer','www-edit'],
        ssh_key => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAuWBfUCv72LTLeKjGKzHYjdfir8r8zSmZNuUNjVj4s18WVuFFrsxUM1ffk7MtLhWmC3HVj7u8SP3eXXCdbtRiv8pC1SvMdVAbub7qkqtqPP+hW9UP6mX1KveAAcxITYQQR+5kK1gDlkhk78JsBRbjpzaN1l5FE3Uvt6UVk8WKUElObOrZBT6uUS1USaGfEr0dfk+Lwk83YrqKVWK4imP5XrjIgsN9iq7d+6gT7kQn7MjqPYhA8T5bpqDgo5rdwn/MM2tsIYPsfCd/4qa6uR/mbiswCdESXJ1z6dRvC1ufoyEAxMLbXdcuoDA8cEnYgdnKv24Uey460sWcL76+yvu4fQ=='
    }

    users::basic {'geert':
        roles   => ['test'],
        ssh_key => 'AAAAB3NzaC1yc2EAAAADAQABAAACAQDL4YcjyKqzokaJN1qmkQWzxHT4tkorzXk7b2nusco8xBKt16+c1d/57nLVKmmdm+FwGXRHKYCubiz646KjunOwDigGSN1K3vbB5pmx2DKsqijmTSf6VYTFR3qLOzaphbWilONw9ziVLrA6L7sbXeRIxUWTRa18y9srv422rqi0mRQst0Z0p8FJxa0vdn0OgiYlS6hv/2Mx+9GszRo3LDCwOQ7u7kYLcLcDZc+0JeT0rMf6KV5ODCjFM0VzArKHuzmVNK++rMaNism1zo1+6aa/gIrZt6M2/uW8mqUQ+aKbUs+jFn+Ik/9tlmMe9AhyklbcIkNs0CMP/97+QgZrvrSe8LbJkyGSSFoCtUA8cXd8iR+G1GsRGN9GtGEEOS9YgsPZA+aNMjh5qPCr/B0INHRKyPE6Gi4LrHIp9XxVbOfgiOeaUTZKTeDjEhTYK4Rw5Ir0KWBu+QIZVfThOz7WG8lKcQ3ekQPHqi0rUfU1JLmy5fBZX88TTldzkjmgEjvIAYB7FKcJ3w29xwtguD29hZ/Oit//10qACEgk9YRatAfYWqM+SgzbX9hZ6ucioDeoXeW6eqppoFug0EKD0jBZNJhVNLAcppI63bNY9a5MVZZ0Mq9xN315tQVjsfJXxbbdvwKpMrhD66lWMR/42z7yRSjR2UZ0iogtbGlYl277QHBvPQ=='
    }

    users::basic {'marten':
        roles   => ['test'],
        ssh_key => 'AAAAB3NzaC1yc2EAAAADAQABAAACAQDOmdog3jVC20B6ROJDDxpEW7kNgMEHIHLD0Uz0ZR7/89ztgmSfvmto2Jn3rxZo2whGbWmQlrAe8fvDFoDZTsRcdBoKMdi4CelPD1QVvcs5ALz4tQQimmSQ7z6+wSFcsWKIigRugxB39rHK58+EZiYqQ8hL5y1OASKzqojlbJNJLpuhoUNmu7MuI2Mz/1HdiJCU/Ay8riH2/4z/i72Tr+iKYih8g79NW68sGbZ2XzmgAGLo6DZOFrZA4SrLngfCB574+WeFqpqLQyKBW25pf2fzS7kuCvPzfpRxm2R+4kVUrF3j+1L0SzKC1SLRqHW1AgA2PC9kzsRtgzQ9xYKMZf80W8x5xpoyUGBlJB3lO9fR0YOWaDz/vzKZt3FOUcJFf+TbktjRXwifqcHbic4fDfGmj5MaxcPHqo4qg7xl3UTTJelZgmxYnr9pBheTDxSCec9+EqLg+NmWNgzcUuZfFM9tyUVnvtfk1iB0332kBSYZ4MsCxnMocy+9mz+UDClZ2/iCuoWQZThpP3wlpEX7TsSGdDrXBsy2Hy+icmn66Gzifd+fvmqSbU+CNEjH/H/UlimYwqOa8v7x4kNcq6Cs+7Jiq/mY7ILmm/M3rUBx9RJVTO+jZlcrPow7T2+m7vkLl/c0fegaD+K01Kn8m98Ejgwttg5rf3o/jgitkiM/2G/c8w=='
    }

    users::basic { 'lan':
        roles   => ['developer','www-edit'],
        ssh_key => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAoxg2EjL8iiEW93EXDVHNsYEefkuHd8v+sU+KiqGES5v1RdPrypWDR4qQqHbTrCfsyDexeq1zL2Pzd5Y35PQoBPPZSu2yq0ElbxOerLMilb++NxolkFBzzTO+WO8aQo4QVzXqcDbo91DWAb/xUkCGgYmVuSULJr1GYs097D4ShMAKNWNGwA+X4YZlUWXExnsJ8DGh8bhpStnNxY2+AwKLUiG0z8UMSxRWipNoN4rbGwhZ6Iozslgd8SHylLZX7NTkxy9Ammvjy4KKnQ8DLaXJxf49/mwOqDMTiYVAUTffdu/JHLD5TFJyPcqgeoQEQCsoXQ1nOdRaqVMu5CIXZlsd1Q=='
    }

    # removed users
    users::remove_user { ['neha']: }
    users::remove_user { ['lauri']: }
    users::remove_user { ['dan']: }
    users::remove_user { ['carl']: }
    users::remove_user { ['adrian']: }

    Class['Users::Groups'] -> Users::Basic<||>
}
