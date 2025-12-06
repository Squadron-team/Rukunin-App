package com.squadronteam.rukunin

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider
import es.antonborri.home_widget.HomeWidgetLaunchIntent

class ActivityWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.activity_widget).apply {
                // Calendar data
                val currentDay = widgetData.getInt("widget_current_day", 1)
                val currentMonth = widgetData.getString("widget_current_month", "Januari") ?: "Januari"
                val hasEvents = widgetData.getBoolean("widget_has_events", false)
                
                // Current activity data
                val title = widgetData.getString("widget_title", "Kegiatan Warga") ?: "Kegiatan Warga"
                val description = widgetData.getString("widget_description", "Memuat...") ?: "Memuat..."
                val date = widgetData.getString("widget_date", "") ?: ""
                val time = widgetData.getString("widget_time", "") ?: ""
                val location = widgetData.getString("widget_location", "") ?: ""
                val count = widgetData.getInt("widget_count", 0)
                
                // Next activity data
                val nextTitle = widgetData.getString("widget_next_title", "") ?: ""
                val nextDate = widgetData.getString("widget_next_date", "") ?: ""
                val nextTime = widgetData.getString("widget_next_time", "") ?: ""

                // Set calendar
                setTextViewText(R.id.widget_calendar_day, currentDay.toString())
                setTextViewText(R.id.widget_calendar_month, currentMonth)
                
                // Set current activity
                setTextViewText(R.id.widget_title, title)
                setTextViewText(R.id.widget_description, description)
                
                if (hasEvents) {
                    setTextViewText(R.id.widget_date, date)
                    setTextViewText(R.id.widget_time, time)
                    setTextViewText(R.id.widget_location, location)
                    setViewVisibility(R.id.widget_current_activity, android.view.View.VISIBLE)
                    setViewVisibility(R.id.widget_empty_state, android.view.View.GONE)
                    
                    // Show next activity if exists
                    if (nextTitle.isNotEmpty()) {
                        setTextViewText(R.id.widget_next_title, nextTitle)
                        setTextViewText(R.id.widget_next_datetime, "$nextDate • $nextTime")
                        setViewVisibility(R.id.widget_next_activity, android.view.View.VISIBLE)
                    } else {
                        setViewVisibility(R.id.widget_next_activity, android.view.View.GONE)
                    }
                    
                    // Show count badge if more activities
                    if (count > 2) {
                        setTextViewText(R.id.widget_count_badge, "+${count - 2}")
                        setViewVisibility(R.id.widget_count_badge, android.view.View.VISIBLE)
                    } else {
                        setViewVisibility(R.id.widget_count_badge, android.view.View.GONE)
                    }
                } else {
                    setViewVisibility(R.id.widget_current_activity, android.view.View.GONE)
                    setViewVisibility(R.id.widget_next_activity, android.view.View.GONE)
                    setViewVisibility(R.id.widget_empty_state, android.view.View.VISIBLE)
                    setTextViewText(R.id.widget_empty_title, title)
                    setTextViewText(R.id.widget_empty_description, description)
                }

                val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java
                )
                setOnClickPendingIntent(R.id.widget_container, pendingIntent)
            }

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
