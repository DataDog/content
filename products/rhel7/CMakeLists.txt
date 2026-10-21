# Sometimes our users will try to do: "cd rhel7; cmake ." That needs to error in a nice way.
if("${CMAKE_SOURCE_DIR}" STREQUAL "${CMAKE_CURRENT_SOURCE_DIR}")
    message(FATAL_ERROR "cmake has to be used on the root CMakeLists.txt, see the Building ComplianceAsCode section in the Developer Guide!")
endif()

set(PRODUCT "rhel7")

ssg_build_product(${PRODUCT})

ssg_build_html_ref_tables("${PRODUCT}" "table-${PRODUCT}-{ref_id}refs" "cis")

ssg_build_html_cce_table(${PRODUCT})

if(SSG_AMZN_DERIVATIVES_ENABLED)
    ssg_build_derivative_product(${PRODUCT} "amzn" "amzn2")
endif()
