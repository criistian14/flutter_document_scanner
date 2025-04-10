package com.christian.flutterDocumentScanner

enum class FilterType(val filterValue: String) {
    NATURAL("NATURAL_FILTER"),
    GRAY("GRAY_FILTER"),
    ECO("ECO_FILTER");

    companion object {
        fun from(filter: String): FilterType {
            return values().find { it.filterValue.equals(filter, ignoreCase = true) }
                ?: throw IllegalArgumentException("Unsupported filter type: $filter")
        }
    }
}
