// TODO: right now there is no way to define how an enum
// is stringified, the current behavior is to stringify as the exact name
// replace when https://github.com/winglang/wing/issues/6470 is resolved
pub enum FieldType {
  plain_text,
  mrkdwn
}

pub struct Section {
  fields: Array<Field>;
}

pub struct Field {
  type: FieldType;
  text: str;
}

pub enum BlockType {
  section
}

pub struct Block {
  type: BlockType;
  fields: Array<Field>;
}

/// Represents a Message block see: https://api.slack.com/block-kit
pub inflight class Message {
  pub sections: MutArray<Section>;
  new() {
    this.sections = MutArray<Section>[];
  }

  pub addSection(section: Section) {
    this.sections.push(section);
  }

  /// Returns Json representation of message
  pub toJson(): Json {
    let blocks = MutArray<Block>[];
    for section in this.sections {
      blocks.push({
        type: BlockType.section,
        fields: section.fields
      });
    }
    return Json.parse(Json.stringify(blocks));
  }
}
