//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <booking_and_publish_slots/booking_and_publish_slots_plugin.h>
#include <url_launcher_linux/url_launcher_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) booking_and_publish_slots_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "BookingAndPublishSlotsPlugin");
  booking_and_publish_slots_plugin_register_with_registrar(booking_and_publish_slots_registrar);
  g_autoptr(FlPluginRegistrar) url_launcher_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "UrlLauncherPlugin");
  url_launcher_plugin_register_with_registrar(url_launcher_linux_registrar);
}
