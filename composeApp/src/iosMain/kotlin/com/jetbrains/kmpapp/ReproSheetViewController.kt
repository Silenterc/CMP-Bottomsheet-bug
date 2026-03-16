package com.jetbrains.kmpapp

import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.ui.window.ComposeUIViewController

fun ReproSheetViewController() = ComposeUIViewController {
    MaterialTheme {
        Surface(
            color = MaterialTheme.colorScheme.background,
            contentColor = MaterialTheme.colorScheme.onBackground,
        ) {
            ReproSheetScreen()
        }
    }
}
