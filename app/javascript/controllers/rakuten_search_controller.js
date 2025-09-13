import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="rakuten-search"
export default class extends Controller {
	static targets = ["keyword"]
  connect() {
  }

	search() {
		const csrfToken = document.getElementsByName('csrf-token')[0].content; // CSRFトークンを取得
		const options = {
			method: "GET", // GETメソッドを指定
			headers: {
				'Accept': 'application/json',
				'Content-Type': 'application/json',
				'X-CSRF-Token': csrfToken // CSRFトークンを設定
			}
		};
		const params = {
			keyword: `インク ${this.keywordTarget.value}`
		};

		const query_params = new URLSearchParams(params);
		const displayResultWrapper = document.getElementById("rakuten-result");

		fetch("/admin/products/search" + "?" + query_params, options)
			.then(results => results.json())
			.then(results => {
				if (results) {
					let resultListHtml = "";

					for (let i in results) {
						// 取得した楽天の商品ページURLと画像、商品名を変数に保存（商品価格ナビAPIと商品検索APIでパラメータが違うのでどちらかを取得）
						const resultUrl = results[i]["params"]["productUrlPC"] || results[i]["params"]["itemUrl"]
						const resultImage = results[i]["params"]["mediumImageUrl"] || results[i]["params"]["mediumImageUrls"][0]
						const resultName = results[i]["params"]["productName"] || results[i]["params"]["itemName"]
						//検索結果表示用のHTMLを構築
						resultListHtml += `<li>
																<input type="radio" name="result" value="${resultUrl},${resultImage}" data-action="click->rakuten-search#set">
																<figure>
																	<img src="${resultImage}" />
																</figure>
																<div>
																	${resultName}
																</div>
															</li>`;
					}
					// 既存の検索結果の表示をリセット
					displayResultWrapper.innerHTML = ''
					// 楽天の検索結果を画面上に表示
					displayResultWrapper.insertAdjacentHTML('beforeend', resultListHtml);
				} else {
					console.error("結果が取得出来ませんでした");
				}
			});
	}

	set(e) {
		const radioButton = e.currentTarget;
		const rakutenData = radioButton.value.split(",");
		const url = document.getElementById("product_productUrl");
		const image = document.getElementById("product_imageUrl");
		url.value = rakutenData[0];
		image.value = rakutenData[1];
	}
}
