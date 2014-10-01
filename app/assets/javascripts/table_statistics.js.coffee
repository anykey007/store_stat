ready = ->
  rows = []
  subDomain = $("#datatable").attr("data-sub-domain")
  storeParam = "&store_id=" + $("#datatable").attr("data-store-id")
  formatdate = undefined
  if subDomain is "month"
    formatdate = d3.time.format("%b %Y")
  else
    formatdate = d3.time.format("%b %d %Y")
  d3.json "/api/statistic/all?sub_domain=" + subDomain + storeParam, (error, csv) ->
    d3.keys(csv.average_dwell_time).forEach (key) ->
      row = {}
      row.dt = formatdate(new Date(parseInt(key) * 1000))
      row.adt = parseFloat(csv.average_dwell_time[key]).toFixed(2)
      row.uvc = parseFloat(csv.unique_visitors_count[key]).toFixed(2)
      row.rvp = parseFloat(csv.repeating_visitors_percent[key] or 0.0).toFixed(2)
      rows.push row
      return

    table = d3.select("#datatable").append("table")
    thead = table.append("thead")
    tbody = table.append("tbody")
    thead.append("th").text "Date"
    thead.append("th").text "Avg time"
    thead.append("th").text "Unique visitors"
    thead.append("th").text "Repeating visitors (%)"
    thead.append("th").text ""
    tr = tbody.selectAll("tr").data(rows).enter().append("tr")
    td = tr.selectAll("td").data((d) ->
      [
        d.dt
        d.adt
        d.uvc
        d.rvp
      ]
    ).enter().append("td").text((d) ->
      d
    )
    width = 80
    height = d3.select("table")[0][0].clientHeight
    mx = 10
    radius = 2
    addChart = (type) ->

      # Now add the chart column
      d3.select("#datatable tbody tr").append("td").attr("id", "chart" + type).attr("width", width + "px").attr "rowspan", rows.length
      chart = d3.select("#chart" + type).append("svg").attr("class", "chart").attr("width", width).attr("height", height)
      maxMu = 0
      minMu = Number.MAX_VALUE
      i = 0
      while i < rows.length
        maxMu = rows[i][type]  if rows[i][type] > maxMu
        minMu = rows[i][type]  if rows[i][type] < minMu
        i++
      dates = rows.map((t) ->
        t.dt
      )
      xscale = d3.scale.linear().domain([
        minMu
        maxMu
      ]).range([
        mx
        width - mx
      ]).nice()
      yscale = d3.scale.ordinal().domain(dates).rangeBands([
        0
        height
      ])
      chart.selectAll(".xaxislabel").data(xscale.ticks(2)).enter().append("text").attr("class", "xaxislabel").attr("x", (d) ->
        xscale d
      ).attr("y", 10).attr("text-anchor", "middle").text String
      chart.selectAll(".xaxistick").data(xscale.ticks(2)).enter().append("line").attr("x1", (d) ->
        xscale d
      ).attr("x2", (d) ->
        xscale d
      ).attr("y1", 10).attr("y2", height).attr("stroke", "#eee").attr "stroke-width", 1
      chart.selectAll(".line").data(rows).enter().append("line").attr("x1", (d) ->
        xscale d[type]
      ).attr("y1", (d) ->
        yscale(d.dt) + yscale.rangeBand() / 2
      ).attr("x2", (d, i) ->
        (if rows[i + 1] then xscale(rows[i + 1][type]) else xscale(d[type]))
      ).attr("y2", (d, i) ->
        (if rows[i + 1] then yscale(rows[i + 1].dt) + yscale.rangeBand() / 2 else yscale(d.dt) + yscale.rangeBand() / 2)
      ).attr("stroke", "#777").attr "stroke-width", 1
      pt = chart.selectAll(".pt").data(rows).enter().append("g").attr("class", "pt").attr("transform", (d) ->
        "translate(" + xscale(d[type]) + "," + (yscale(d.dt) + yscale.rangeBand() / 2) + ")"
      )
      pt.append("circle").attr("cx", 0).attr("cy", 0).attr("r", radius).attr("opacity", .5).attr "fill", "#ff0000"
      return

    addChart "adt"
    addChart "uvc"
    addChart "rvp"
    return

$(document).ready ready
$(document).on "page:load", ready
