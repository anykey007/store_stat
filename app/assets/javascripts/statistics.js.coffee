# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  baseOptions =
    subDomain: $("#centered-block").attr("data-sub-domain"),
    start: new Date(2014, 0)
    cellSize: 25
    tooltip: true

  if baseOptions.subDomain is "month"
    $.extend baseOptions,
      domain: "year"
      range: 1

  if baseOptions.subDomain is "week"
    $.extend baseOptions,
      domain: "month"
      range: 4

  if baseOptions.subDomain is "day"
    $.extend baseOptions,
      domain: "month"
      range: 4

  storeParam = "&store_id=" + $("#centered-block").attr("data-store-id")
  average_dwell_time = new CalHeatMap()
  average_dwell_time.init $.extend({}, baseOptions,
    itemSelector: "#average_dwell_time"
    data: "/api/statistic/average_dwell_time?sub_domain=" + baseOptions.subDomain + storeParam
    legend: [20, 40, 60, 100]
    itemName: [
      "minute"
      "minutes"
    ]
  )
  unique_visitors = new CalHeatMap()
  unique_visitors.init $.extend({}, baseOptions,
    itemSelector: "#unique_visitors"
    data: "/api/statistic/unique_visitors?sub_domain=" + baseOptions.subDomain + storeParam
    legend: [5, 10, 50, 100]
    itemName: [
      "visitor"
      "visitors"
    ]
  )
  repeating_visitors = new CalHeatMap()
  repeating_visitors.init $.extend({}, baseOptions,
    itemSelector: "#repeating_visitors"
    data: "/api/statistic/repeating_visitors?sub_domain=" + baseOptions.subDomain + storeParam
    legend: [10, 30, 60, 90]
    itemName: [
      "%"
      "%"
    ]
  )
  allCharts = [
    average_dwell_time
    unique_visitors
    repeating_visitors
  ]
  $("#navigationSelector-next").on "click", (event) ->
    $.map allCharts, (val, i) ->
      val.next baseOptions.range
      return

    return

  $("#navigationSelector-previous").on "click", (event) ->
    $.map allCharts, (val, i) ->
      val.previous baseOptions.range
      return

    return

  return

$(document).ready ready
$(document).on "page:load", ready