package com.qordoba.cli

import com.qordoba.cli.grammar.StringExtractorBaseListener
import com.qordoba.cli.grammar.StringExtractorParser.StringLiteralContext

/**
  * Listener callbacks for processing parser nodes in a useful way
  */
class StringExtractor extends StringExtractorBaseListener {
  override def enterStringLiteral(ctx: StringLiteralContext): Unit = {
    val literal: String = ctx.StringLiteral().toString

    println(s"StringLiteral found: ${literal}")
  }

}
