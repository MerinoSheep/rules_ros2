""" Implements a rule to generate a ROS package's version.h from package.xml.

ament_cmake auto-generates these headers at install time using configure_file()
on a CMake template. rules_ros2 builds packages with plain cc_library and never
replicates that step, so downstream code that does e.g.
`#include <rclcpp/version.h>` (typical use: the *_VERSION_GTE macros) fails to
compile.

The generated header is emitted under `include/<package_include>/version.h`,
matching the path ROS consumers use; pair this with `includes = ["include", ...]`
on the cc_library that exposes the package.
"""

def _version_header_impl(ctx):
    output = ctx.actions.declare_file(
        "include/{}/version.h".format(ctx.attr.package_include),
    )
    args = ctx.actions.args()
    args.add("--package-xml", ctx.file.package_xml)
    args.add("--template", ctx.file._template)
    args.add("--prefix", ctx.attr.package_include.upper())
    args.add("--output", output)
    ctx.actions.run(
        inputs = [ctx.file.package_xml, ctx.file._template],
        outputs = [output],
        executable = ctx.executable._generator,
        arguments = [args],
        mnemonic = "Ros2VersionHeader",
        progress_message = "Generating include/%s/version.h" % ctx.attr.package_include,
    )
    return [DefaultInfo(files = depset([output]))]

version_header = rule(
    doc = "Generate `include/<package_include>/version.h` from a ROS package.xml. " +
          "The output uses <PREFIX>_VERSION_MAJOR/MINOR/PATCH/STR/GTE macros, " +
          "where PREFIX is `package_include.upper()`.",
    attrs = {
        "package_include": attr.string(
            mandatory = True,
            doc = "Subdirectory under `include/` for the output header, e.g. " +
                  "\"rclcpp\" or \"ament_index_cpp\". Also uppercased to form " +
                  "the macro prefix.",
        ),
        "package_xml": attr.label(
            mandatory = True,
            allow_single_file = True,
            doc = "Label of the ROS package's package.xml.",
        ),
        "_generator": attr.label(
            default = "@com_github_mvukov_rules_ros2//repositories:version_header_gen",
            executable = True,
            cfg = "exec",
        ),
        "_template": attr.label(
            default = "@com_github_mvukov_rules_ros2//repositories:version_header.h.in",
            allow_single_file = True,
        ),
    },
    implementation = _version_header_impl,
)
