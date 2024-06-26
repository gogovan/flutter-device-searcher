package hk.gogovan.flutter_device_searcher

/**
 * Exceptions to be relayed to Flutter side. Refer to Flutter side exception_codes.dart for error codes to use.
 */
open class PluginException(val code: Int, message: String?) : Exception(message)
