package newcastleuniversity.joehonour.message_graph_converters

import newcastleuniversity.joehonour.messages.Frame

object FrameConverter {

  def toCreateScript(frame: Frame) : String = {
    s"""
       |MERGE (object:Frame {
       |  uuid:'${frame.frame_uuid}'})
       |""".stripMargin
  }
}
