require "rails_helper"

RSpec.describe Tag, type: :model do
  describe "バリデーション" do
    it "name と color があれば有効" do
      tag = build(:tag)
      expect(tag).to be_valid
    end

    it "name が空なら無効" do
      tag = build(:tag, name: "")
      expect(tag).not_to be_valid
    end

    it "name が重複すると無効" do
      create(:tag, name: "重要")
      duplicate = build(:tag, name: "重要")
      expect(duplicate).not_to be_valid
    end

    it "color が #RRGGBB 形式でなければ無効" do
      tag = build(:tag, color: "red")
      expect(tag).not_to be_valid
      expect(tag.errors[:color]).to be_present
    end

    it "color が #RRGGBB 形式なら有効" do
      tag = build(:tag, color: "#ff0000")
      expect(tag).to be_valid
    end
  end
end
