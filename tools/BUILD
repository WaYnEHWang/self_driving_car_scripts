load("//tools:cpplint.bzl", "cpplint")

package(default_visibility = ["//visibility:public"])

cc_binary(
    name = "auto_routing",
    srcs = ["auto_routing.cc"],
    deps = [
        "//modules/routing:routing_lib",
        "//modules/routing/proto:routing_proto",
    ],
)

cc_binary(
    name = "auto_pad_terminal",
    srcs = ["auto_pad_terminal.cc"],
    deps = [
        "//cyber",
        "//external:gflags",
        "//modules/canbus/proto:canbus_proto",
        "//modules/common/adapters:adapter_gflags",
        "//modules/common/util",
        "//modules/control/common",
        "//modules/control/proto:control_proto",
    ],
)

cc_binary(
    name = "auto_listener",
    srcs = ["auto_listener.cc"],
    deps = [
        "//cyber",
        "//modules/planning/proto:planning_proto",
        "//modules/planning/proto:decision_proto",
        "//modules/common/adapters:adapter_gflags",
    ],
)

cpplint()
