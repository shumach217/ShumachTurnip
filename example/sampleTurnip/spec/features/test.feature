Feature: テスト

  Scenario: テスト1
    Given コネクション確立
    Given アプリリセット
    Then MainController確認
    When BOOLテスト
    When Charテスト
    When Doubleテスト
    When Floatテスト
    When Intテスト
    When Longテスト
    When LongLongテスト
    When Shortテスト
    When UnsignedCharテスト
    When UnsignedIntテスト
    When NSUIntegerテスト
    When UnsignedLongテスト
    When UnsignedLongLongテスト
    When UnsignedShortテスト
    When "1" MainIndexTabタブ切替
    Then "1" MainIndexTabタブ確認
    When PatternB_2へ進む
    When "set label" Labelセット
    Given コネクション破棄

  Scenario: テスト1
    Given コネクション確立
    Given アプリリセット
    Then MainController確認
    When BOOLテスト
    When Charテスト
    When Doubleテスト
    When Floatテスト
    When Intテスト
    When Longテスト
    When LongLongテスト
    When Shortテスト
    When UnsignedCharテスト
    When UnsignedIntテスト
    When NSUIntegerテスト
    When UnsignedLongテスト
    When UnsignedLongLongテスト
    When UnsignedShortテスト
    When "1" MainIndexTabタブ切替
    Then "1" MainIndexTabタブ確認
    When PatternB_2へ進む
    When "set label part 2" Label2セット
    Given コネクション破棄
