package com.qordoba.cli

/**
  * A single instance of a string literal and where it was found
  */
class StringLiteral(val filename: String,
                    val text: String,
                    val startLineNumber: Int,
                    val startCharIdx: Int, // 0-based index, inclusive
                    val endLineNumber: Int,
                    val endCharIdx: Int  // 0-based index, inclusive
                   ) {

  def toStringArray(): Array[String] = {
    Array[String](
      this.filename,
      this.text,
      this.startLineNumber.toString(),
      this.startCharIdx.toString(),
      this.endLineNumber.toString(),
      this.endCharIdx.toString()
    )
  }
}
