package com.inblack.inblack_orders

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.net.Uri
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider
import org.json.JSONArray

class OrdersWidgetProvider : HomeWidgetProvider() {

    private val rowIds = listOf(
        Triple(R.id.order_row_1, R.id.order_title_1, R.id.order_meta_1),
        Triple(R.id.order_row_2, R.id.order_title_2, R.id.order_meta_2),
        Triple(R.id.order_row_3, R.id.order_title_3, R.id.order_meta_3),
    )

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        val signedIn = widgetData.getString("signed_in", "false") == "true"
        val title = widgetData.getString("title", "") ?: ""
        val openCount = widgetData.getString("open_count", "0") ?: "0"
        val items = runCatching {
            JSONArray(widgetData.getString("items", "[]") ?: "[]")
        }.getOrDefault(JSONArray())

        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.orders_widget)
            views.setTextViewText(R.id.widget_title, if (signedIn) title else "InBlack Orders")
            views.setTextViewText(R.id.widget_count, if (signedIn) openCount else "–")
            views.setContentDescription(R.id.widget_count, "$title $openCount")
            views.setOnClickPendingIntent(
                R.id.widget_header,
                linkIntent(context, "inblack://orders?status=PENDING,PAID,IN_PROGRESS", 0),
            )

            rowIds.forEachIndexed { index, (row, titleId, metaId) ->
                val item = if (signedIn && index < items.length()) items.optJSONObject(index) else null
                if (item == null) {
                    views.setViewVisibility(row, View.GONE)
                } else {
                    val id = item.optString("id")
                    views.setViewVisibility(row, View.VISIBLE)
                    views.setTextViewText(titleId, "$id · ${item.optString("name")}")
                    views.setTextViewText(
                        metaId,
                        "${item.optString("status")} · ${item.optString("amount")}",
                    )
                    views.setOnClickPendingIntent(
                        row,
                        linkIntent(context, "inblack://orders/${Uri.encode(id)}", index + 1),
                    )
                }
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }

    private fun linkIntent(context: Context, link: String, requestCode: Int): PendingIntent {
        val intent = Intent(Intent.ACTION_VIEW, Uri.parse(link)).apply {
            setPackage(context.packageName)
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP)
        }
        return PendingIntent.getActivity(
            context,
            requestCode,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
    }
}
