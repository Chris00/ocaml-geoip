#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>

#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/custom.h>
#include <caml/fail.h>


#include <GeoIP.h>
#include <GeoIPCity.h>

// Handle the gi struct

#define Context_val(v) (*((GeoIP **) Data_custom_val(v)))

void finalize (value v) {
  GeoIP *gi = Context_val(v) ;
  GeoIP_delete(gi);
  return ;
}

static struct custom_operations context = {
  "geoip.gi",
  //(void *)finalize,
  custom_finalize_default,
  custom_compare_default,
  custom_hash_default,
  custom_serialize_default,
  custom_deserialize_default
};

value alloc_context (GeoIP *gi) {
  value v = alloc_custom(&context, sizeof(GeoIP *), 0, 1);
  Context_val (v) = gi;
  return v;
}

// Create the context

value ocaml_create_context (value dat) {
  CAMLparam1(dat);

  GeoIP *gi = GeoIP_open(String_val (dat), GEOIP_INDEX_CACHE);
  if (gi == NULL) caml_failwith("Can't initialize gi") ;
  GeoIP_set_charset(gi, GEOIP_CHARSET_UTF8);

  CAMLreturn (alloc_context (gi));
}


// Perform the lookup

static const char * _mk_NA( const char * p ){
 return p ? p : "ZZ";
}

value ocaml_GeoIP_record_by_addr (value context, value address){
  CAMLparam2(context, address);
  CAMLlocal1(result) ;

  GeoIPRecord *gir = GeoIP_record_by_addr (Context_val(context), String_val (address)) ;

  if (gir == NULL) caml_failwith("Can't initialize gir") ;

  result = caml_alloc (7 ,0);

  Store_field(result, 0, (caml_copy_string(_mk_NA (gir->country_code))));
  Store_field(result, 1, (caml_copy_string(_mk_NA (gir->country_code3))));
  Store_field(result, 2, (caml_copy_string(_mk_NA (gir->country_name))));
  Store_field(result, 3, (caml_copy_string(_mk_NA (gir->city))));
  Store_field(result, 4, (caml_copy_double(gir->latitude)));
  Store_field(result, 5, (caml_copy_double(gir->longitude)));
  Store_field(result, 6, (caml_copy_string(_mk_NA (gir->region))));

  GeoIPRecord_delete(gir);
  CAMLreturn (result) ;
}
