# Đánh giá Dev Flow — 12.10.2026

## Kết luận

Nên nâng cấp có chọn lọc: giữ Dev Flow làm luồng chính, mở rộng nhận diện stack, giảm phần hướng dẫn luôn tải và tăng bằng chứng kiểm chứng. Không cần sao chép toàn bộ bộ skill Addy Osmani. Không skill nào bảo đảm mã nguồn tuyệt đối không lỗi.

Bản sửa đã được cài vào `~/.agents/skills/dev-flow`; global `AGENTS.md` đã được rút gọn và cập nhật routing, giữ nguyên quy tắc riêng của máy. Plugin đã nâng qua CLI chính thức lên tag `0.6.12`. Installer hiện tại vẫn dành cho macOS; phạm vi đa nền tảng ở đây là công việc lập trình và kiểm chứng các target.

## Nguồn đối chiếu

Đã đọc skill đang cài và xác nhận nội dung giống bản repo trước sửa. Trước nâng cấp, README pin plugin `0.6.9` và danh mục skill của phiên trỏ vào cache `0.6.9`. README hiện pin `0.6.12`.

GitHub API trả về đầu nhánh `main` là [`1be8e34187e34647bb83adc3a1323b26ae6f6abe`](https://github.com/addyosmani/agent-skills/commit/1be8e34187e34647bb83adc3a1323b26ae6f6abe), thời điểm commit `2026-10-10T08:28:48Z`. Manifest ở commit này ghi `0.6.12`. Đây là snapshot main đã kiểm tra, không phải xác nhận tag phát hành hoặc tương thích đầy đủ trên máy này.

Các nguồn chính:

- [Codex setup](https://github.com/addyosmani/agent-skills/blob/1be8e34187e34647bb83adc3a1323b26ae6f6abe/docs/codex-setup.md): tránh nạp sẵn meta-router; helper SessionStart không còn được nối vào plugin.
- [So sánh từ 0.6.9](https://github.com/addyosmani/agent-skills/compare/0.6.9...1be8e34187e34647bb83adc3a1323b26ae6f6abe): xác nhận xóa `hooks/hooks.json`, bổ sung quản lý context và ranh giới tiếp tục phiên.
- [Context engineering](https://github.com/addyosmani/agent-skills/blob/1be8e34187e34647bb83adc3a1323b26ae6f6abe/skills/context-engineering/SKILL.md): bảo vệ yêu cầu, lỗi đang xử lý và quyết định; tóm tắt thay vì giữ log dài.
- [Debugging](https://github.com/addyosmani/agent-skills/blob/1be8e34187e34647bb83adc3a1323b26ae6f6abe/skills/debugging-and-error-recovery/SKILL.md): tái hiện, cô lập nguyên nhân, sửa và phòng tái phát.
- [Doubt-driven development](https://github.com/addyosmani/agent-skills/blob/1be8e34187e34647bb83adc3a1323b26ae6f6abe/skills/doubt-driven-development/SKILL.md): review có điểm dừng và cân nhắc chi phí; không phù hợp để tự động bật cho mọi chỉnh sửa.
- [OpenAI: rút gọn skills và prompts](https://developers.openai.com/blog/rethinking-skills-and-prompts-for-gpt-6-astra): mô tả ngắn, tải chi tiết theo nhu cầu, tránh chỉ dẫn trùng lặp.
- [OpenAI: đánh giá skill](https://developers.openai.com/blog/eval-skills): kiểm tra hành vi và kết quả thay vì chỉ cảm giác prompt tốt hơn.

## So sánh và quyết định

| Khía cạnh | Dev Flow cũ | Quyết định trong bản sửa |
| --- | --- | --- |
| Phạm vi | Description và routing chỉ nêu Flutter/Next.js/Python | Description độc lập ngôn ngữ; đọc manifest, scripts, CI và toolchain cho stack bất kỳ |
| Chi phí tải hướng dẫn | Core có cả danh sách specialist dài | Tách specialist và platform discovery thành reference chỉ đọc khi cần |
| Meta-router | Đã yêu cầu không tải router trùng | Giữ nguyên; lưu ý văn bản skill không thể gỡ nội dung hook đã được host nạp |
| Tính đúng | Có test theo mức rủi ro | Làm rõ regression test thất bại đúng nguyên nhân trước sửa, truy vết caller/boundary, kiểm tra consumer khi sửa shared code |
| Tiếp tục tác vụ | Checkpoint khái quát | Ghi lệnh/kết quả, lỗi hiện tại, phê duyệt; kiểm tra lại trạng thái thực tế sau resume |
| Debug lặp | Chưa nêu rõ | Mỗi lần thử cần giả thuyết hoặc bằng chứng mới; không lặp nguyên lệnh vô ích |
| Đa nền tảng | References tập trung ba stack | Phân biệt host với target; không suy ra Windows/Linux/device thành công từ check trên Mac |
| Multi-agent | Chưa nêu mặc định | Một agent mặc định; chỉ giao việc khi được phép và có lợi ích cụ thể |
| Review-only | Description nhận review nhưng workflow thiên sửa code | Không tự sửa implementation khi chỉ được yêu cầu review |

Không đưa ngưỡng context 75% của upstream thành quy tắc bắt buộc: skill không phải lúc nào cũng có số đo context đáng tin cậy hoặc quyền chủ động compact. Không áp dụng toàn bộ checklist runtime/release cho sửa tài liệu. Các gate bắt buộc của repo vẫn được giữ.

## Kích thước và chi phí

Đếm bằng Python `len(text.split())` và `len(text)` trên `SKILL.md` trước/sau:

| Chỉ số | Trước | Sau |
| --- | ---: | ---: |
| Số từ core | 827 | 714 |
| Ký tự core | 6.122 | 5,361 |
| Ký tự description | 321 | 156 |

Core giảm khoảng 13.7% số từ và 12.4% ký tự; description giảm 51,4%. Đây không phải phép đo token bằng tokenizer, tổng context của phiên, hóa đơn hay tốc độ. Hai reference mới tăng tổng dung lượng gói và có thể làm một tác vụ cần chúng tải nhiều hơn. Lợi ích dự kiến đến từ chọn lọc ngữ cảnh và bớt thử lại, cần benchmark để xác nhận.

Phiên hiện tại đã nhận meta-skill từ hook cũ lúc bắt đầu; không thể gỡ nội dung đã nạp khỏi lịch sử. Plugin mới đã được xác nhận không còn `hooks/hooks.json`. Cần mở phiên mới sau khi khởi động lại Codex để xác nhận hiệu quả ở thời điểm khởi động. Không sửa cache plugin bằng tay.

## Kiểm chứng và giới hạn

- Kiểm tra liên kết nội bộ của skill và whitespace diff: đạt.
- Đối chiếu thủ công các tình huống dưới đây với hướng dẫn: có đường xử lý; đây không phải chạy tác vụ bằng agent độc lập.
- Validator chính thức `quick_validate.py`: đạt cho bản repo và bản đã cài. PyYAML chỉ được cài trong venv tạm `/tmp/dev-flow-validation-env`, không thêm dependency production hay thay Python toàn máy.
- So sánh từng file và danh sách file repo với bản đã cài: khớp. Global AGENTS.md khớp bản sao lưu sau khi hoàn nguyên riêng dòng routing trong phép kiểm tra.
- Plugin manifest xác nhận `0.6.12`, 25 skill, không còn đăng ký SessionStart qua `hooks/hooks.json`.
- Chưa chạy A/B trên repo ứng dụng, chưa đo token/latency/chi phí, chưa kiểm chứng target Windows/Linux/mobile thực tế.

## Bộ tình huống A/B đề xuất

| Yêu cầu thử | Kết quả quan sát cần đạt |
| --- | --- |
| Sửa typo tài liệu | Diff hẹp, không tạo spec/test/code không cần thiết |
| Sửa bug Go trong monorepo | Chọn đúng module và regression test, giữ consumer đúng |
| Sửa API Rust có nhiều feature | Nhận diện feature/target, kiểm tra consumer, hỏi trước thay contract chưa được duyệt |
| Sửa Vue/React không dùng Next.js | Không áp đặt App Router hay lệnh Next.js |
| Lỗi Swift/Android trên máy thiếu SDK | Kiểm tra phần làm được, nêu chính xác target chưa kiểm chứng |
| Lỗi Python/Flutter đã có test | Test chứng minh lỗi trước sửa và qua sau sửa; không làm yếu test |
| Review-only trên .NET/C++ | Báo lỗi có chứng cứ, không sửa implementation |
| Migration/auth hoặc CI publish | Giữ gate và quyền hạn; không dùng credentials/deploy ngoài phạm vi |
| Resume sau gián đoạn, working tree đã đổi | Đọc checkpoint và trạng thái thật; không dùng kết quả cũ làm bằng chứng mới |

Chạy bản cũ và mới trên cùng snapshot repo, model, quyền, bộ công cụ và yêu cầu; lặp nhiều lần vì kết quả có dao động. So sánh hoàn thành đúng, hồi quy, diff ngoài phạm vi, số lần sửa lại, input/cached/output token nếu host cung cấp, và thời gian. Tính chi phí theo giá/account thực tế; không coi tỷ lệ từ giảm là tỷ lệ tiền giảm. Chỉ triển khai rộng khi chất lượng không giảm và chi phí tổng có lợi.

## Cài đặt và khôi phục

- Sao lưu trước nâng cấp: `/Users/tuanminh/.codex/backups/dev-flow-upgrade-20261012-120340` (AGENTS.md, cấu hình hiện có và skill cũ). Không đưa các bản sao lưu cấu hình vào Git.
- Tag plugin đã cài: `0.6.12`, commit `a06bc63b3f8b829c14b0bbf53d99fefc39d58092`; khác snapshot main được dùng để đánh giá ở trên.
- Cài bằng `codex plugin marketplace remove agent-skills`, đăng ký lại nguồn với `--ref 0.6.12`, rồi `codex plugin add agent-skills@agent-skills`. Đây là đổi nguồn pin qua CLI, không sửa cache.
- Nếu cần rollback: khôi phục riêng skill và AGENTS.md từ backup sau khi kiểm tra thay đổi mới; đăng ký lại marketplace với pin `0.6.9` và cài lại bằng CLI. Tránh chép đè toàn bộ config nếu có thay đổi cấu hình khác sau nâng cấp.
- Khởi động lại Codex và mở chat mới để nạp đầy đủ skill/plugin mới. Không tự đóng ứng dụng vì có thể làm gián đoạn các chat đang chạy.

## Tối ưu AGENTS.md tiếp theo — 12.10.2026

Global AGENTS.md được rút từ 431 xuống 309 từ (tính cả mục riêng giữ nguyên), làm rõ quyền đã cấp, phạm vi tài nguyên được chỉ định và trạng thái kiểm chứng bị chặn. Bản chung đồng bộ tại `config/AGENTS.md`; mục riêng của máy giữ nguyên từng byte. Sao lưu tại `~/.codex/backups/agents-optimization-20261012-121326/AGENTS.md`.

Installer hiện giữ global AGENTS.md khác template và xuất proposal riêng để review, thay vì ghi đè. Bốn test trong thư mục tạm đã đạt: cài mới/cài lặp, bảo toàn quy tắc riêng và backup skill cũ, từ chối symlink skill, từ chối tham số thiếu. `bash -n install.sh` và `git diff --check` đạt. Không chạy installer thử trên cấu hình thật.
