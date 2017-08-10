package com.qordoba.cli

import com.qordoba.cli.grammar.StringExtractorBaseListener
import com.qordoba.cli.grammar.StringExtractorParser.StringLiteralContext

/**
  * Listener callbacks for processing parser nodes in a useful way
  */
class StringExtractorListener extends StringExtractorBaseListener {
  override def enterStringLiteral(ctx: StringLiteralContext): Unit = {
    val literal: String = ctx.STRING_LITERAL().toString

    println(s"StringLiteral found: ${literal}")
  }

}
