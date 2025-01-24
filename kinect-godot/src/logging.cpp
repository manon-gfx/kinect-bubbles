#include "logging.h"

#include <cstdarg>
#include <cstdio>

#include <godot_cpp/core/error_macros.hpp>

#define BUFFER_SIZE 4096

int log_error(const char* format, ...) {
    va_list args;
    va_start(args, format);

    char buffer[BUFFER_SIZE];
    const int result = vsnprintf(buffer, BUFFER_SIZE, format, args);
    va_end(args);

    ERR_PRINT(buffer);

    return result;
}

int log_warning(const char* format, ...) {
    va_list args;
    va_start(args, format);

    char buffer[BUFFER_SIZE];
    const int result = vsnprintf(buffer, BUFFER_SIZE, format, args);
    va_end(args);

    WARN_PRINT(buffer);

    return result;
}
