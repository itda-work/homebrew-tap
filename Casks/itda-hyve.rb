# 이 파일은 itda-work/itda-hyve 의 packaging/homebrew/itda-hyve.rb.tmpl 에서 scripts/render-cask.sh 로 만든다 — 직접 고치지 않는다.
# 판마다 release-local.sh --publish 가 version·sha256 을 바꿔 push 한다(낸 판의 해시는 다시 바꾸지 않는다).
cask "itda-hyve" do
  arch arm: "arm64", intel: "amd64"

  version "0.14.0"
  sha256 arm:   "76f98620943d4be1efbc994eb2e632aec3b9c73c6d68f7f3c33c177ebc6b6ffb",
         intel: "d955d6733a7b6c039d989d1a61823ce82a0e98b8f4e7957396cf1ef53f5c2cff"

  url "https://github.com/itda-work/itda-hyve.pub/releases/download/v#{version}/itda-hyve-#{version}-darwin-#{arch}.app.zip"
  name "itda-hyve"
  desc "Local bridge for Claude Desktop and ChatGPT to use your mail, web and API keys"
  homepage "https://itda.work/hyve/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :monterey

  app "itda-hyve.app"

  # 로그인 자동 실행(LaunchAgent)은 zap 에서만 지운다 — uninstall 에 두면 brew upgrade 때도 돌아 사용자가 켠 자동 실행이 판마다 꺼진다
  # (Homebrew 7.0.9 실측: upgrade 가 "Removing launchctl service work.itda.hyve.gui"). 앱 경로는 판이 바뀌어도 같아 등록은 그대로 맞다.
  zap launchctl: "work.itda.hyve.gui",
      trash:     [
        "~/.itda/hyve",
        "~/Library/Caches/work.itda.hyve",
        "~/Library/Caches/work.itda.hyve.doc",
        "~/Library/Preferences/work.itda.hyve.doc.plist",
        "~/Library/Preferences/work.itda.hyve.plist",
        "~/Library/WebKit/work.itda.hyve",
        "~/Library/WebKit/work.itda.hyve.doc",
      ]

  caveats <<~EOS
    itda-hyve 는 아직 Apple 공증 전이라 처음 열 때 macOS 가 막습니다(새 판마다 다시 뜰 수 있습니다):
      1. 응용 프로그램 폴더에서 itda-hyve 를 엽니다 → 경고 창에서 "완료"(또는 취소)
      2. 시스템 설정 > 개인정보 보호 및 보안 > 아래쪽 "그래도 열기" → 암호 입력 → "열기"

    Not notarized yet, so macOS blocks the first launch (again after upgrades):
      open itda-hyve, click "Done", then System Settings > Privacy & Security >
      "Open Anyway", enter your password, and click "Open".

    새 판 / New versions: itda-hyve 를 종료(메뉴 막대 아이콘 > 종료)한 뒤
      brew upgrade --cask itda-hyve
    지우기 전 설정 › 일반의 "로그인 시 자동 실행" 을 끄세요. ~/.itda/master.key 는 다른 itda 앱과 함께 써서 zap 도 남깁니다.
  EOS
end
