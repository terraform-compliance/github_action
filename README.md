# terraform-compliance GitHub Action

<img src='https://avatars3.githubusercontent.com/u/61387890' align=right height=100 valign=top><h1 align="center">terraform-compliance</h1>

<div align="center">
  <!-- Website -->
  <a href="https://terraform-compliance.com">
    <img src="https://img.shields.io/badge/website-https%3A%2F%2Fterraform--compliance.com-blue" alt="Website" />
  </a>
  
  <!-- License -->
  <a href="https://pypi.org/project/terraform-compliance/">
    <img src="https://img.shields.io/pypi/l/terraform-compliance.svg" alt="License" />
  </a>

  <!-- PyPI Version -->
  <a href="https://pypi.org/project/terraform-compliance/">
    <img src="https://img.shields.io/pypi/v/terraform-compliance.svg" alt="Package Version" />
  </a>
  
  <a href="https://pepy.tech/project/terraform-compliance">
    <img src="https://pepy.tech/badge/terraform-compliance" alt="Downloads" />
  </a>
</div>

<br />

---


`terraform-compliance` is a lightweight, security and compliance focused test framework against terraform to enable negative testing capability for your infrastructure-as-code.


- __compliance:__ Ensure the implemented code is following security standards, your own custom standards
- __behaviour driven development:__ We have BDD for nearly everything, why not for IaC ?
- __portable:__ just install it from `pip` or run it via `docker`. See [Installation](https://terraform-compliance.com/pages/installation/)
- __pre-deploy:__ it validates your code before it is deployed
- __easy to integrate:__ it can run in your pipeline (or in git hooks) to ensure all deployments are validated.
- __segregation of duty:__ you can keep your tests in a different repository where a separate team is responsible. 
- __why ?:__ why not ?

You can use this action in order to run [terraform-compliance](https://terraform-compliance.com) in your GitHub Actions pipeline. For more information about the tool itself, you can have a look on https://terraform-compliance.com

# How to use this action ?

1. [Enable and Configure](https://help.github.com/en/actions/configuring-and-managing-workflows/configuring-a-workflow) GitHub actions within your respository.
2. Use `terraform-compliance/github-action@main`
3. Supply `plan` and `features` required parameters 
4. Supply optional other parameters


`terraform-compliance` requires to have access to 2 things in order to execute properly

1. terraform plan output (preferably converted to `json` format via `terraform show -json` command)
2. compliance tests that will run against your terraform plan.

# Examples

An example CI pipeline for a terraform might look like this ;

```yml
jobs:
    terraform:
        name: terraform CI
        runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v2
      - uses: hashicorp/setup-terraform@v1

      - name: terraform plan
        id: plan
        run: |
          terraform init && terraform plan -out=plan.out && terraform show -json plan.out > plan.out.json
      
      - name: terraform-compliance
        uses: terraform-compliance/github_action@main
        with:
          plan: plan.out.json
          features: ssh://git@github.com/terraform-compliance/user-friendly-features.git
```

.. or if you want to install `terraform-compliance` in the beginning of the steps and re-use it every time via `run` directive ;

```yml
jobs:
    terraform:
        name: terraform CI
        runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v2
      - uses: hashicorp/setup-terraform@v1
      - uses: terraform-compliance/github_action@main

      - name: terraform plan
        id: plan
        run: |
          terraform init && terraform plan -out=plan.out && terraform show -json plan.out > plan.out.json
      
      - name: terraform-compliance
        id: terraform-compliance from remote repo
        run: |
          terraform-compliance -p /path/to/plan.out.json -f git:ssh://git@github.com/terraform-compliance/user-friendly-features.git

      - name: terraform-compliance
        id: terraform-compliance from local
        run: |
          terraform-compliance -p /path/to/plan.out.json -f /path/to/local
```

Additionaly, in case you want to publish the plan output to the related Pull Request, you can also use this action provided by GitHub as well ;

```yml
      - uses: actions/github-script@0.9.0
        if: github.event_name == 'pull_request'
        env:
          PLAN: "terraform\n${{ steps.plan.outputs.stdout }}"
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
          script: |
            <details><summary>GitHub Plan</summary>

            \`\`\`${process.env.PLAN}\`\`\`

            </details>

            *Pusher: @${{ github.actor }}, Action: \`${{ github.event_name }}\`, Workflow: \`${{ github.workflow }}\`*`;

            github.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: output
            })
```

# What are the parameters I can use ?

| Parameter | Required | Description | Default | Examples |
| --------- | -------- | ----------- | ------- | -------- |
| plan | :white_check_mark: | The plan file that is generated by terraform | | `plan.out`, `plan.out.json` |
| features | :white_check_mark: | The feature files that will be run against terraform plan | `./tests/`, `ssh://github.com/<org|user>/<repo>` |
| quit-early | | Action will fail immediately on the first failure | false | |
| no-failure | | Action will not fail even the tests fail | false | | 
| silent | | Output of the tests will be substantially silenced | false | | 
| version | | Specific `terraform-compliance` version that you want to use within the action | | 

# What if my feature files are within a private repository ?

Have a look on [setup-git-credentials](https://github.com/marketplace/actions/setup-git-credentials) action for doing it in a better way than
providing SSH private keys. 

This action will also solve your problems while downloading modules from remote private repositories on `terraform init`

