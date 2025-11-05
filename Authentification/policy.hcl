# Read a secret in a KV
v2 secrets engine
path
"secret/data/
capabilities =
[[" list",,"
}
# Prevent access to a path
path
"secret/data/
capabilities =
[["
}
# Create and read ACL policies
path
"sys/policies/
capabilities =
[[" list",," read",," create",,"
}
# Manage auth methods broadly across Vault
path
"
capabilities =
[[" create",," update",," read",," list",," delete",,"
}
# Read the 'bird' path under any top level path within the KV
v2 engine
path
"secret/data/+/
capabilities =
[[" read",,"list", “
}
9
●
Written in HCL or
JSON
●
Six different
capabilities
●
Two wildcard
characters