# JSON libs compare and benchmark

## Supported libs
- /UI2/CL_JSON
- XCO library
- [ABAPify JSON](https://github.com/abapify/json) ( ZCL_JSON )
- Standard identity transformation

## Feature comparison

| Feature                     | UI2 | XCO | Abapify | Identity
|-----------------------------|-----|-----|---------|----------
| Camel case                  | ✅ | ✅ | ✅ | ❌
| Custom case                 | ❔ | ✅ | ✅ | ❌
| Custom transformation       | ❌ | ✅ | ❌ | ❌
| Suppress initial components | ❌ | ❌ | ✅ | ✅ 
| Support data refs (render)  | ✅ | ❌ | ✅ | ⚠️
| Support polymorphic tables  | ✅ | ❌ | ✅ | ⚠️ 
| Root array                  | ✅ | ✅ | ✅ | ❌ 

## Camel case
Camel case is usually the most common case in JSON world. Removing separators like - or _ helps to reduce the size of payload and devs use a special camelCase notation.
Let's see how we can reach this with our libs:
- UI2 has pretty_name flag which enforces camel case automatically
```abap
result = /ui2/cl_json=>serialize( EXPORTING data = data pretty_name = abap_true ).
```
- XCO lib uses quite flexible mechanism of custom transformations including predefined such as `xco_cp_json=>transformation->underscore_to_camel_case`
```
result = xco_cp_json=>data->from_abap( data )->apply( it_transformations = VALUE #(
        ( xco_cp_json=>transformation->underscore_to_camel_case )
    )  )->to_string( ).
```
- ABAPify ZCL_JSON uses camel case by default
```
json = zcl_json=>render( data ).
```
- Identity transformation supports only asJSON format which means all names come as UPPER_SNAKE_CASE notation

## Custom case
- UI2 ( to be checked )
- XCO as it's shown above `apply` function accepts callbacks which you can use for any rules
- Abapify JSON supports also `case` parameter which implements `ZIF_ABAP_CASE` interfaces introduced in [case](https://github.com/abapify/case) library
```
json = zcl_json=>render( data = data case = new lcl_your_own_case( ) ).
" or use predefined like
json = zcl_json=>render( data = data case = zcl_abap_case=>kebab( ) ).
```
## Suppress initial components 
[initial_components](https://help.sap.com/doc/abapdocu_latest_index_htm/latest/en-US/index.htm?file=abapcall_transformation_options.htm#!ABAP_ADDITION_3@3@) - is a standard option for identity transformation. 

You can use it like
```
 call transformation id
      source data = data
      options
        initial_components = 'suppress'
      result xml data(lv_xml).
```
Abapify JSON is using identity transformation internally and therefore propagates this option and supports all of available modes:
- include
- suppress_boxed
- suppress

In Abapify JSON you can provide it explicitly if you want
```
json = zcl_json=>render( data = data initial_components = 'include' ).
```

In UI2 and XCO library i was not able to find such methods. Please contribute if you found.


## Support data refs

Another interesting feature of identity transformation is [data_refs](https://help.sap.com/doc/abapdocu_latest_index_htm/latest/en-US/index.htm?file=abapcall_transformation_options.htm#!ABAP_ADDITION_2@2@)
By default they are ignored. You can include data refs into your JSON but they will be output in a very weird manner:
```json
{"DATA":{"SAMPLE":{"%type":"cls:ZCL_JSON_BENCHMARK.TY_MAIN","%val":{"ID":1,"NAME":"Benchmark Data",
```

So for this example:
```
 types:
            BEGIN OF root_ts,
              name TYPE REF TO data,
            END OF root_ts.
        data(ref_to_sample) = VALUE root_ts( name = ref #( sample-name ) ).
```

UI2 and Abapify libs seem to handle refs correctly, but XCO just dumps.. 
```
Ref to data
/ui2/cl_json
{"name":"Benchmark Data"}  
zcl_json
{"name":"Benchmark Data"}  
identity
{"DATA":{"NAME":{"%type":"xsd:string","%val":"Benchmark Data"}}}  
```

Both libs also support `table of ref to data` which is also nice.

## Performance evaluation

### Rendering and parsing (binary format)

Setup:
- Same data object
- 100 iterations

![image](https://github.com/user-attachments/assets/859d6211-5c69-45a8-89f7-fc038c8401ef)

As you can see identity is almost free, XCO is disappointingly slow. UI2 seems working 2-3 times faster than Abapify currently.

to be continued....

  
  
  

