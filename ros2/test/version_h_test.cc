// Copyright 2026 The rules_ros2 Authors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// Verifies version_header is wired into each package's cc_library by
// reaching the synthesized headers and exercising their _VERSION_GTE macros.

#include "ament_index_cpp/version.h"
#include "rclcpp/version.h"

static_assert(AMENT_INDEX_CPP_VERSION_GTE(0, 0, 0),
              "AMENT_INDEX_CPP_VERSION_GTE expands and is true for 0.0.0");
static_assert(RCLCPP_VERSION_GTE(0, 0, 0),
              "RCLCPP_VERSION_GTE expands and is true for 0.0.0");

int main() { return 0; }
