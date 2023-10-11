network:
  version: 1
  config:
    - type: physical
      name: ens32
      subnets:
        - type: static
          address: ${IP_ADDR}/${NETMASK}
          gateway: ${GATEWAY}
    - type: nameserver
      address:
        - ${DNS1}
        - ${DNS2}
      search:
        - example.org
